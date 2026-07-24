# RF-Track module for ELENA lattice simulations

This module provides RF-Track scripts to simulate the ELENA lattice, including tracking with and without collective effects, as well as simulations using RF-Track `Volume` elements.

---

## ELENA lattice

The ELENA lattice is stored in:

```
elena.tws
```

The lattice can be generated using **acc-models-elena**.

Before generating the lattice, the following files should be adapted to the desired machine scenario:

```
scenarios/highenergy/highenergy.beam
scenarios/highenergy/highenergy.str
```

---

# Lattice simulations

To run simulations using the ELENA lattice, use the following scripts:

### Without collective effects

```
run_nothing.m
```

Runs the lattice tracking without any collective effects.

---

### Space Charge + IBS

```
run_all.m
```

Runs the simulation including:

- Space Charge (SC)
- Intra-Beam Scattering (IBS)

---

### Space Charge only

```
run_SC.m
```

Runs the simulation including Space Charge effects only.

---

The transport table containing the beam evolution and simulation results is generated automatically.

---

# Volume simulations

RF-Track allows the lattice elements to be inserted into a `Volume` object for tracking.

## Lattice inside a Volume (recommended)

To run the ELENA lattice inserted into an RF-Track Volume:

```
run_tracking.m
```

This method is recommended for lattice simulations using RF-Track Volume elements.

---

## Static field simulations

For simulations using static electromagnetic field maps:

### 1. Generate the mesh

```
run_volume_tracking.m
```

This script creates the required mesh for the volume simulation.

---

### 2. Run the tracking

```
run_nothing_V.m
```

Runs the particle tracking using the generated static field mesh.

---

# Initial bunch generation

The initial particle distributions are stored in:

```
Results/
│
├── initial_particles_L.dat
└── initial_particles_V.dat
```

where:

- `initial_particles_L.dat`  
  Initial bunch used for lattice simulations.

- `initial_particles_V.dat`  
  Initial bunch used for volume simulations.

---

The corresponding bunch generation scripts are:

### Lattice bunch

```
generate_bunch_L.m
```

Generates the initial particle distribution for lattice simulations.

---

### Volume bunch

```
generate_bunch_V.m
```

Generates the initial particle distribution for volume simulations.

---

```