SELECT TICKET_ID as ID,
	U1.ID as SUBMITTERS_ID,
	U1.EMAIL AS SUBMITTERS_EMAIL,
	SubmittedPhone as SUBMITTERS_PHONE
FROM(
	SELECT *,
		REPLACE(REPLACE(CleanName, SUBSTRING_INDEX(CleanName, ' ', -1),''),' ', '') AS FirstName,
		SUBSTRING_INDEX(CleanName, ' ', -1) AS LastName,
		CONCAT (REPLACE(REPLACE(CleanName, SUBSTRING_INDEX(CleanName, ' ', -1),''),' ', ''),".",SUBSTRING_INDEX(CleanName, ' ', -1),"@obi.org") as USEREMAIL
	FROM(
		SELECT *,
			LEFT(CustomerPhone,13) as SubmittedPhone,
			LEFT(Submitter,(fullnamelength-2)) as CleanName
		FROM(
			SELECT *,
			SUBSTRING_INDEX(Submitter,' ',-1) as LastNames,
				length(SUBSTRING_INDEX(Submitter,' ',-1)) as LastNameCounts,
				length(Submitter) as fullnamelength
			FROM(
				SELECT     ID AS TICKET_ID,
					STATUS_NAME,
					SUBSTRING_INDEX(
						SUBSTRING_INDEX(
							SUBSTRING_INDEX(
								SUBSTRING_INDEX(
									SUBSTRING_INDEX(
										SUBSTRING_INDEX(
											SUBSTRING_INDEX(
												SUBSTRING_INDEX(
													SUBSTRING_INDEX(Customer, 'Phone', 1)
													,'*',1)
												, 'Phon',1)
											,'(',1)
										, ' - ',1)
									, 'Pho',1)
								, 'with',1)
							, 'W/',1)
						, 'w/',1) as Submitter,
					CustomerPhone,
					Original_Sub
				FROM (
					select 
						HD_TICKET.ID as ID,
						HD_TICKET.SUMMARY,
						U2.FULL_NAME as Original_Sub,
						LEFT(SUBSTRING_INDEX(HD_TICKET.SUMMARY, 'Phone Number:', -1),15)AS CustomerPhone,
						CONVERT(LEFT(SUBSTRING_INDEX(HD_TICKET.SUMMARY, 'First and Last Name:', -1),25), CHAR) AS Customer,
					    HD_STATUS.NAME AS STATUS_NAME,
					    HD_STATUS.ORDINAL as STATUS_ORDINAL,
					    HD_IMPACT.ORDINAL as IMPACT_ORDINAL,
					    HD_CATEGORY.ORDINAL as CATEGORY_ORDINAL,
					    HD_PRIORITY.ORDINAL as PRIORITY_NUMBER,
					    STATE,
					    if(M1.ID is null, 'z', concat('a', M1.NAME)) as sort_MACHINE_NAME,
						if((datediff(DUE_DATE, now()) = 0), 2, if((datediff(DUE_DATE, now())<0), 1, 3)) as SORT_OVERDUE_STATUS,
						if(unix_timestamp(TIME_OPENED) > 0, TIME_OPENED, 1<<62) as SORT_TIME_OPENED,
						if(unix_timestamp(TIME_STALLED) > 0, TIME_STALLED, 1<<62) as SORT_TIME_STALLED,
						if(unix_timestamp(TIME_CLOSED) > 0, TIME_CLOSED, 1<<62) as SORT_TIME_CLOSED,
						if(unix_timestamp(ESCALATED) > 0, ESCALATED, 1<<62) as SORT_ESCALATED,
						if(unix_timestamp(HD_TICKET.CREATED) > 0, HD_TICKET.CREATED, 1<<62) as SORT_TIME_CREATED,
						if(unix_timestamp(HD_TICKET.MODIFIED) > 0, HD_TICKET.MODIFIED, 1<<62) as SORT_MODIFIED,
						if(unix_timestamp(HD_TICKET.DUE_DATE) > 0, HD_TICKET.DUE_DATE, 1<<62) as SORT_DUE_DATE,
						case upper(STATE)
						when 'CLOSED' then unix_timestamp(HD_TICKET.TIME_CLOSED) - unix_timestamp(HD_TICKET.TIME_OPENED)
						when 'OPENED' then unix_timestamp() - unix_timestamp(HD_TICKET.TIME_OPENED)
						else unix_timestamp() - unix_timestamp(HD_TICKET.CREATED) end as AGE,
						if ((LENGTH(U1.FULL_NAME) = 0), U1.USER_NAME, U1.FULL_NAME) as OWNER_NAME,
						U1.FULL_NAME as OWNER_FULLNAME,
						U1.EMAIL as OWNER_EMAIL,
						if (U1.ID is null, 'z', concat('a', if ((LENGTH(U1.FULL_NAME) = 0), U1.USER_NAME, U1.FULL_NAME))) as SORT_OWNER_NAME,
						if ((LENGTH(U2.FULL_NAME) = 0), U2.USER_NAME, U2.FULL_NAME) as SUBMITTER_NAME,
						U2.FULL_NAME as SUBMITTER_FULLNAME,
						U2.EMAIL as SUBMITTER_EMAIL,
						if (U2.ID is null, 'z', concat('a', if ((LENGTH(U2.FULL_NAME) = 0), U2.USER_NAME, U2.FULL_NAME))) as SORT_SUBMITTER_NAME,
						if (U3.ID is null, 'z', concat('a', if ((LENGTH(U3.FULL_NAME) = 0), U3.USER_NAME, U3.FULL_NAME))) as SORT_APPROVER_NAME,
						if(APPROVAL='rejected', 'Rejected', if(APPROVAL='info', 'More Info Needed', if(APPROVAL='approved', 'Approved', if(HD_TICKET.APPROVER_ID>0, 'Pending', '')))) as APPROVAL_STATUS, Q.NAME as QUEUE_NAME
					from (HD_TICKET, HD_PRIORITY, HD_STATUS, HD_IMPACT, HD_CATEGORY)
						LEFT JOIN USER U1 on U1.ID = HD_TICKET.OWNER_ID
						LEFT JOIN USER U2 on U2.ID = HD_TICKET.SUBMITTER_ID
						LEFT JOIN USER U3 on U3.ID = HD_TICKET.APPROVER_ID
						LEFT JOIN HD_QUEUE Q on Q.ID = HD_TICKET.HD_QUEUE_ID
						LEFT JOIN MACHINE M1 on M1.ID = HD_TICKET.MACHINE_ID
					where HD_PRIORITY.ID = HD_PRIORITY_ID
						and HD_STATUS.ID = HD_STATUS_ID
						and HD_IMPACT.ID = HD_IMPACT_ID
						and HD_CATEGORY.ID = HD_CATEGORY_ID
						and U2.FULL_NAME = 'examplefilter'
						and HD_STATUS.NAME <> 'closed'
				) as ticketdetails
			) as ticketdetailswithlookups
		) as pleasegodmakethisstop
	) as noiammakingyoustronger
	WHERE REPLACE(REPLACE(CleanName, SUBSTRING_INDEX(CleanName, ' ', -1),''),' ', '') <> ""
		and CleanName NOT LIKE '%refused%'
) as cantdontwontstop
LEFT JOIN USER U1 on U1.EMAIL = USEREMAIL
WHERE U1.EMAIL <> ""
GROUP BY TICKET_ID
