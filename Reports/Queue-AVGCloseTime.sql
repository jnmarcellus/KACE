--You will need to know the queueID which is pretty easy to see if you navigate in KACE to the queue you are wanting to report off of. I left in a filter for queues that you did not want to include too

SELECT
	AVG(DATEDIFF(HD_TICKET.TIME_CLOSED, HD_TICKET.CREATED)) as Ranges
FROM HD_TICKET
	LEFT JOIN HD_QUEUE ON HD_QUEUE_ID = HD_QUEUE.ID
	LEFT JOIN HD_CATEGORY ON HD_CATEGORY_ID = HD_CATEGORY.ID
	LEFT JOIN HD_STATUS ON HD_STATUS_ID = HD_STATUS.ID
WHERE HD_STATUS.STATE = 'closed'
 AND ((HD_TICKET.TIME_CLOSED >= DATE_FORMAT(NOW(), '%Y-%m-01')))
 AND ((HD_QUEUE.ID <> 7) AND (HD_QUEUE.ID <> 12))
 AND HD_QUEUE.ID = 10
