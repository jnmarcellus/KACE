## Create Custom SQL Rule and use the following to select the records
## Use this query to discover any tickets that are missing a Title from the Users
SELECT HD_TICKET.ID
FROM HD_TICKET
  left join HD_QUEUE on HD_QUEUE_ID = HD_QUEUE.ID
WHERE TITLE = ""
  and ((HD_QUEUE.ID <> 1) AND (HD_QUEUE.ID <>12))


## Rule for UPDATE SQL: In the rule section - this will take the first 30 characters in teh summary and create a Title From it
UPDATE
	HD_TICKET
SET
	HD_TICKET.TITLE = LEFT(HD_TICKET.SUMMARY, 30)
WHERE
	(HD_TICKET.ID IN (<TICKET_IDS>))
