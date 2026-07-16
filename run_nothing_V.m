addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
RF_Track.number_of_threads = 8;

% Gaussian buch
M = load('Results/initial_particles_V.dat');
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 5e7;
B0 = Bunch6dT(mass, charge, Q, M);

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes
h = 4 % up to 4 bunches
length = L.get_length();
c = 299792458;
f_rf = h * c * beta_rel / length;

V = Volume();
V.odeint_algorithm = 'analytic';
V.add(L, 0.0, 0.0, 0.0, reference='entrance');
V.verbosity = 1;
V.t_max_mm = L.get_length() / beta_rel *1e3 * 100;
V.dt_mm = 300;
V.tt_dt_mm = 10000;
B1 = V.track(B0);
T = V.get_transport_table("%mean_Z %emitt_x %emitt_y %sigma_Z %N");
save -text Results/transport_table_nothing.dat T

