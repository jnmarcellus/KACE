select HD_TICKET.ID, 
	HD_QUEUE.NAME as Category,
  HD_TICKET.Time_Closed as time_sec
from HD_TICKET
  left join HD_QUEUE on HD_QUEUE_ID = HD_QUEUE.ID
  left join HD_CATEGORY on HD_CATEGORY_ID = HD_CATEGORY.ID
  left join HD_STATUS on HD_STATUS_ID = HD_STATUS.ID
where HD_STATUS.STATE = 'closed'
  and HD_TICKET.TIME_CLOSED > '2023-01-01 00:00:01'
  and ((HD_QUEUE.ID <> 2) AND (HD_QUEUE.ID <> 1))
  order by time_sec
