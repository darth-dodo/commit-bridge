class CommitParser < ApplicationService
  include GitWebhookServiceHelpers
  # {
  #       "sha": "78c4ef902de35c95a6b403c3f5c2e536cfbaab2e",
  #       "message": "CHORE: Cleaner logging output\n\nRef: #happ-1224",
  #       "date": "2018-05-24T16:00:49Z",
  #       "author": {
  #         "id": 21031067,
  #         "name": "paul",
  #         "email": "paul@suitepad.de"
  #       }
  #     }

  def initialize(context)
    super()

    @context = Hashie::Mash.new(context)
    @event = @context.event
    @event_user_info = @context.author
    @commit_message = @context.message
    @tickets = []
  end

  def validate
    error('Commit Author is required!') if @event_user_info.blank?
    error('Commit message is required!') if @commit_message.blank?
    if @event.present? && !@event.is_a?(Event)
      @event = Event.find_by(id: @event)
    end
    error('Event is required!') if @event.blank?

    validate_commit_message_structure

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?

    @commit = Commit.find_by_sha(@context.sha)

    ActiveRecord::Base.transaction do
      if @commit.present?
        @tickets = @commit.tickets
      else

        # for creating new commits
        ActiveRecord::Base.transaction do
          find_or_create_user_object
          raise_rollback_unless_valid

          create_commit_object
          raise_rollback_unless_valid

          find_or_create_ticket_objects_from_commit_message
          raise_rollback_unless_valid

          attach_commit_to_tickets
          raise_rollback_unless_valid
        end
      end

      return false unless valid?

      # irrespective of whether the commit is new or not, process for the event
      attach_commit_to_event
      raise_rollback_unless_valid

      attach_release_to_commit if @event.release?
      raise_rollback_unless_valid
    end

    return false unless valid?

    create_service_response_data
    valid?
  end

  private

  # validators
  def validate_commit_message_structure
    # we are assuming the commit messages are strict and not doing any regex validations
  end

  # executors

  def find_or_create_project_object(project_code)
    project = Project.find_or_create_by(code: project_code)
    if project.errors.present?
      error(project.errors.full_messages.map do |current_error|
        current_error.prepend("Project Creation Error: ")
      end)
      valid?
    else
      project
    end
  end

  def find_or_create_ticket_object(project_object, ticket_code)
    ticket = Ticket.find_or_create_by(project: project_object, code: ticket_code)

    if ticket.errors.present?
      error(ticket.errors.full_messages.map do |current_error|
              current_error.prepend("Ticket Creation Error for Code #{ticket_code}: ")
            end)
    else
      ticket
    end
  end

  def find_or_create_ticket_objects_from_commit_message
    ticket_slugs = @commit_message.rpartition('Ref:')[-1]
    ticket_slugs.strip!
    ticket_slugs = ticket_slugs.split(',')

    ticket_slugs.each do |current_slug|
      current_slug = current_slug.sub("#", "").split("-")
      project_code = current_slug[0].strip
      ticket_code = current_slug[1].to_i

      project_object = find_or_create_project_object(project_code)

      if project_object.present?
        ticket_object = find_or_create_ticket_object(project_object, ticket_code)
        @tickets << ticket_object
      end
    end
  end

  def create_commit_object
    @commit = Commit.new
    @commit.message = @commit_message
    @commit.sha = @context.sha
    @commit.commit_timestamp = @context.date
    @commit.user = @user
    @commit.commit_type = extract_commit_type_from_message

    unless @commit.save
      error(@commit.errors.full_messages.map do |current_error|
        current_error.prepend("Commit Creation Error: ")
      end)
    end
  end

  def extract_commit_type_from_message
    # assuming the commit message structure is strict and perfect
    @commit_message.partition(":")[0].downcase
  end

  def attach_commit_to_event
    event_commit = EventCommit.new
    event_commit.event = @event
    event_commit.commit = @commit
    unless event_commit.save
      error(event_commit.errors.full_messages.map do |current_error|
        current_error.prepend("Event Commit Mapping Error: ")
      end)
    end
  end

  def attach_release_to_commit
    release_event = @event.release
    if release_event.blank?
      error("Event should have release attached to it!")
      return
    end
    @commit.release = release_event
    unless @commit.save
      error(@commit.errors.full_messages.map do |current_error|
        current_error.prepend("Commit and Release Mapping Error: ")
      end)
    end
  end

  def attach_commit_to_tickets
    @commit.tickets << @tickets
  end

  def create_service_response_data
    @service_response_data[:commit] = @commit.as_json(only:
    [:sha, :message]).merge(linked_tickets_count: @commit.tickets.size)
    @service_response_data[:tickets] = @tickets
  end
end
