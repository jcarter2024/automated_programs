A programme to automatically compile WRF on SeaWulf

* - * - STRUCTURE - * - 
. New_build.sh
. recompile_wrf.sh
. recompile_wps.sh

Asks would you like to 
a) Compile from scratch 
b) Recompile 
c) Retrieve data 
d) Run case(s)

> a, b, c, d, or x to cancel 

Specify that the user should be on Milan node 
a) Compile from scratch [current script that builds entire program]

- Call the recompile script as part of this 

Ask c) again 
- Would the user like GFS or ECMWF (later)
- User enters date range for simulation, we will retrieve this from the GFS servers by generating script 
- Call optional WPS script to geogrid and ungrib data (batch submit ungrib and metgrid)

Ask d) again (shall we run this case?)
	./case run with argument of metgrid dates 
	yes —> we run real and wrf for the metgrid files, create new directory on scratch based on dates, run in place