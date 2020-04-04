def delete_all_records
  puts(EventTicket.all.delete_all)
  puts(EventCommit.all.delete_all)
  puts(TicketCommit.all.delete_all)
  puts(Ticket.all.delete_all)
  puts(Project.all.delete_all)
  puts(Commit.all.delete_all)
  puts(Release.all.delete_all)
  puts(Event.all.delete_all)
end
