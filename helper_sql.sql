select
et.id as event_ticket_id,
e.id as event_id,
e.event_type,
t.code as ticket_code,
p.code as project_code
from
event_tickets et,
events e,
tickets t,
projects p
where
et.event_id = e.id
and et.ticket_id = t.id
and t.project_id = p.id
order by event_ticket_id;
