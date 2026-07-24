<h2> RF-Track module to run ELENA lattice </h2>

Lattice at elena.tws
Can be generated from acc-models-elena, where scenarios/highenergy/highenergy.beam and highenergy.str should be properly changed.

<h3> To run LATTICE simulations: </h3>
- run_nothing.m for no collective effects
- run_all.m for SC + IBS
- run_SC.m for IBS
Transport table with results will be stored.

<h3> To run VOLUME simulations: </h3>
- Running the lattice in a volume (recommended):
run_tracking.m -  to run the lattice inserted in a Volume

- Static Field:
run_volume_tracking.m to create a mesh 
run_nothing_V.m to run the simulation

The initial bunches can be found at
Results/initial_particles_L.dat
Results/initial_particles_V.dat

and their generators in:
generate_bunch_L.m -- for Lattice
generate_bunch_V.m -- for Volume