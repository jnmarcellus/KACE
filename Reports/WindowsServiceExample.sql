###### This Report SQL identifies a certain Windows Service called Delivery Optimization that is running on KACE Managed Computers and reports it back ######

#### Select Statement ####

SELECT
	L.NAME AS 'Label',
	M.NAME AS 'System',
	NS.DISPLAY_NAME AS 'Service Display Name',
	NS.NAME AS 'Service Name',
	NS.STARTUP_TYPE AS 'Startup Type',
	NS.STATUS AS 'Service Status',
	M.LAST_INVENTORY,
        M.LAST_REBOOT
FROM MACHINE M
	LEFT JOIN MACHINE_LABEL_JT MLJT ON M.ID = MLJT.MACHINE_ID
	LEFT JOIN LABEL L ON MLJT.LABEL_ID = L.ID
	LEFT JOIN MACHINE_NTSERVICE_JT MNJT ON M.ID = MNJT.MACHINE_ID
	LEFT JOIN NTSERVICE NS ON MNJT.NTSERVICE_ID = NS.ID
WHERE 
	M.OS_NAME LIKE '%Windows%'
	AND NS.DISPLAY_NAME like 'Delivery Optimization%'
	AND NS.STATUS != 'SERVICE_STOPPED'
	AND NS.STARTUP_TYPE = 'SERVICE_DISABLED'
GROUP BY M.NAME, NS.NAME
ORDER BY L.NAME ASC, M.NAME ASC
