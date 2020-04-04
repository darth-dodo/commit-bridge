def delete_all_records
  EventTicket.all.delete_all
  EventCommit.all.delete_all
  TicketCommit.all.delete_all
  Ticket.all.delete_all
  Project.all.delete_all
  Commit.all.delete_all
  Release.all.delete_all
  Event.all.delete_all
end
