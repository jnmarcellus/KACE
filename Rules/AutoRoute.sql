
########## This SQL Rule Load Balances Tickets inside of a queue. It Contains multiple filtering options to ensure not all tickets are auto routed ###########

#### Select Query ####

SELECT
	HD_TICKET.ID
FROM
	HD_TICKET
WHERE 
	HD_TICKET.OWNER_ID = 0
	AND HD_TICKET.HD_QUEUE_ID = 10
	AND HD_TICKET.HD_STATUS_ID <> 74
	AND (HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%' or HD_TICKET.SUMMARY NOT LIKE '%Filter This Thing If Needed%')
LIMIT 1;


#### Update Query ####
#### You will notice I limit specific Owner IDs to ensure it specific to owners inside a queue because not all queue members need tickets shared ####
#### I set my custom rule time to 15 minutes so every 15 minutes 1 ticket is routed to a new person to give them time to finish out the previous ticket ####

UPDATE
	HD_TICKET
SET
	HD_TICKET.OWNER_ID =
	(
		SELECT OWNER_ID
		FROM (
		SELECT
			COUNT(HD_TICKET.ID) AS TICKETS,
		   HD_TICKET.OWNER_ID,
		   U1.USER_NAME
		FROM
			HD_TICKET
		JOIN USER U1 ON HD_TICKET.OWNER_ID=U1.ID
		WHERE 
			HD_TICKET.HD_QUEUE_ID = 10
			AND (HD_TICKET.OWNER_ID=1493 OR HD_TICKET.OWNER_ID=1497 OR HD_TICKET.OWNER_ID=3158 OR HD_TICKET.OWNER_ID=4414 OR HD_TICKET.OWNER_ID=4840)
			AND HD_TICKET.HD_STATUS_ID <> 74
		GROUP BY OWNER_ID
		ORDER BY TICKETS ASC
		) AS STUFF
		LIMIT 1
	)
WHERE
	(HD_TICKET.ID IN (<TICKET_IDS>))
