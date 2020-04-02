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
    @user = @context.author
    @commit_message = @context.message
  end

  def validate
    error('Event information is required!') if @event.blank?
    error('Commit Author is required!') if @user.blank?
    error('Commit message is required!') if @commit_message.blank?
    unless @event.is_a?(Event)
      @event = Event.find(@event)
    end
    error('Event is required!') if @event.blank?

    validate_commit_message_structure

    super()
    valid?
  end

  def execute
    super()
    return false unless valid?

    find_or_create_user_object unless @user.is_a?(User)
    raise_rollback_unless_valid

    find_or_create_ticket_objects_from_commit_message

    create_commit_object
    raise_rollback_unless_valid

    attach_commit_to_event
    raise_rollback_unless_valid

    attach_release_to_commit if @event.release?
    raise_rollback_unless_valid

    attach_commit_to_tickets

    valid?
  end

  private

  # validators
  def validate_commit_message_structure
    # we are assuming the commit messages are strict and not doing any regex validations
  end

  # executors

  def find_or_create_project_object
  end

  def find_or_create_ticket_objects
  end

  def find_or_create_ticket_objects_from_commit_message
    @commit_message.rpartition('Ref:')
  end

  def create_commit_object
    @commit = Commit.new
    @commit.message = @commit_message
    @commit.sha = @context.sha
    @commit.commit_timestamp = @context.date
    @commit.user = @user

    unless @commit.save
      error(@commit.errors.full_messages.map do |current_error|
        current_error.prepend("Commit Creation Error: ")
      end)
    end
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
    error("Event should have release attached to it!") if release_event.blank?
    @commit.release = release_event
    unless @commit.save
      error(@commit.errors.full_messages.map do |current_error|
        current_error.prepend("Commit and Release Mapping Error: ")
      end)
    end
  end
end
