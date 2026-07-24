addpath('/home/pdesirev/rf-track-2.1')
RF_Track;

% Gaussian buch
M = load('Results/initial_particles_L.dat');
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 1e7;
B0 = Bunch6d(mass, charge, Q, M);

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;
% Define IBS
% Read lattice file

% ALWAYS CHECK THAT THE TWISS FILE WAS GENERATED WITH THE GOOD PARAMETERS
% acc-models-elena/scenarios/highenergy.beam -- change if needed
L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes
h = 4 % up to 4 bunches
length = L.get_length();
c = 299792458;
f_rf = h * c * beta_rel / length;

A = L{'*'};
for i = 1:numel(A)
    elname = A{i}.get_name();
    l_rf = A{i}.get_length();
    if strcmp(elname, 'LNR.ACWO2.0530')
        P = Pillbox_Cavity(20.0e3/l_rf, f_rf,l_rf, 1.0);
        P.set_phid(-90.0);
        A{i}.replace_with(P);
    end
    if l_rf == 0.0 
        A{i}.remove;
    end
end
P_final = L.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]))

% TURNS
emitt_x = [];
emitt_y = [];
emitt_4d = [];
bunch_length = [];
T = [];
num_turns = 1000;
for i=1:num_turns
    L.set_nsteps(500);
    L.set_tt_nsteps(1);
    B1 = L.track(B0);
    B0 = B1;
    T = [T; L.get_transport_table("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N")];
    save -ascii 'Results/transport_table_LATTICE_Nothing.dat' T
end

