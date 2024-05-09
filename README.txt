A programme to automatically compile WRF on SeaWulf

* - * - STRUCTURE - * - 
auto_Main --> main access point
auto_resources/ --> contains several supporting scripts
	|-> recompile_wps.sh
	|-> recompile_wrf.sh
	|-> library_functions  = "Contains builders for libraries" 
	|-> retrieve_data.sh = "should download GFS but unfinished"
        |-> full_build.sh = "builds libraries and compiles WRF / WPS in one sweep"

Running
-------
clone directory and issue . auto_Main
select:
	-  full recompile (a) [Working]
	-  recompile WPS / WRF (b) (c) [Working - requires Build_WRF to be located in same directory as automated_programs ]

To do
-----

 . Automate the following:
	- Retrieve data
        - link data and Vtable
        - copy WPS and WRF to scratch 
        - ungrib and metgrid via slurm 
        - link the metgrid files to wrf
        - run real and wrf via slurm 

Specify that the user should be on Milan node 
automatically update the wrf out dir to be scratch




