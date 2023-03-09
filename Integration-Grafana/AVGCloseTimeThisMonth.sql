select
	AVG(DATEDIFF(HD_TICKET.TIME_CLOSED, HD_TICKET.CREATED)) as Ranges
from HD_TICKET
	left join HD_QUEUE on HD_QUEUE_ID = HD_QUEUE.ID
	left join HD_CATEGORY on HD_CATEGORY_ID = HD_CATEGORY.ID
	left join HD_STATUS on HD_STATUS_ID = HD_STATUS.ID
where HD_STATUS.STATE = 'closed'
 and ((HD_TICKET.TIME_CLOSED > DATE_FORMAT(NOW(), '%Y-%m-01')))
 and ((HD_QUEUE.ID <> 7) AND (HD_QUEUE.ID <> 12))
 and HD_QUEUE.NAME = 'IT - Service Desk'