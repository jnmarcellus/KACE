select 
    MACHINE.NAME,
    SOFTWARE.DISPLAY_VERSION
from (MACHINE, MACHINE_LABEL_JT, LABEL)
     LEFT JOIN MACHINE_SOFTWARE_JT 
      ON MACHINE.ID = MACHINE_SOFTWARE_JT.MACHINE_ID
     LEFT JOIN SOFTWARE 
      ON MACHINE_SOFTWARE_JT.SOFTWARE_ID = SOFTWARE.ID
where MACHINE.ID = MACHINE_LABEL_JT.MACHINE_ID
  AND SOFTWARE.DISPLAY_NAME LIKE "VMware Tools"
  AND CONVERT(LEFT(SOFTWARE.DISPLAY_VERSION,2), INT) < 11
and   MACHINE_LABEL_JT.LABEL_ID = LABEL.ID
group by MACHINE.NAME
