######### This SQL Rule just reassigns a ticket from one owner to another automatically ##########
##### The Select Query #####

select
  HD_TICKET.*,
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
    if(APPROVAL='rejected', 'Rejected', if(APPROVAL='info', 'More Info Needed', if(APPROVAL='approved', 'Approved', if(HD_TICKET.APPROVER_ID>0, 'Pending', '')))) as APPROVAL_STATUS,
    Q.NAME as QUEUE_NAME
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
    and ((  ( exists  (select 1 from USER where HD_TICKET.OWNER_ID = USER.ID and USER.FULL_NAME = 'USERNAMEGOESHERE')) ) and HD_TICKET.HD_QUEUE_ID = 10 )
    
##### The Update Query #####

update HD_TICKET, USER as T5
    set HD_TICKET.OWNER_ID = T5.ID
  where T5.USER_NAME = 'OtherUSERNAMEGOESHERE' and 
        (HD_TICKET.ID in (<TICKET_IDS>))
