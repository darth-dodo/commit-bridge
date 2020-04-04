def delete_all_records
  puts(EventCommitSync.all.delete_all)
  puts(EventTicket.all.delete_all)
  puts(EventCommit.all.delete_all)
  puts(TicketCommit.all.delete_all)
  puts(Ticket.all.delete_all)
  puts(Project.all.delete_all)
  puts(Commit.all.delete_all)
  puts(Release.all.delete_all)
  puts(Event.all.delete_all)
  puts(Repository.all.delete_all)
  puts(User.all.delete_all)
end

def count_all
  puts(EventTicket.all.size)
  puts(EventCommit.all.size)
  puts(TicketCommit.all.size)
  puts(Ticket.all.size)
  puts(Project.all.size)
  puts(Commit.all.size)
  puts(Release.all.size)
  puts(Event.all.size)
  puts(Repository.all.size)
  puts(User.all.size)
end
