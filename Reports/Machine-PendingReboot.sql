select
  DISTINCT NAME
from
  MACHINE
  join KBSYS.KONDUCTOR_TASK KT on KT.KUID = MACHINE.KUID and KT.TYPE like 'kpatch%' and KT.PHASE ='reboot pending'
WHERE
  MACHINE.NAME NOT LIKE 'frontprefixfilterhere%'
order by MACHINE.NAME
