addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
RF_Track_number_of_threads = 8;
SC = SC = SpaceCharge_PIC_FreeSpace(32, 32, 32);
RF_Track.SC_engine = SC;

%%%%%%% BEAM CHARACTERIZATION
N_particles = 10000; % number of macroparticles per bunch
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 1e7;

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;
% Define IBS

% Gaussian buch
M = load('Results/initial_particles_L.dat');
B0 = Bunch6d(mass, charge, Q, M);

% ALWAYS CHECK THAT THE TWISS FILE WAS GENERATED WITH THE GOOD PARAMETERS
% acc-models-elena/scenarios/highenergy.beam -- change if needed
L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes
% Read lattice file
h = 4 % up to 4 bunches
length = L.get_length();
c = 299792458;
f_rf = h * c * beta_rel / length;

A = L{'*'};
for i = 1:numel(A)
    elname = A{i}.get_name();
    l_rf = A{i}.get_length();
    if strcmp(elname, 'LNR.ACWO2.0530')
        P = Pillbox_Cavity(12.0e3/l_rf, f_rf,l_rf, 1.0);
        P.set_phid(-90.0);
        A{i}.replace_with(P);
    end
    if l_rf == 0.0 
        A{i}.remove;
    end
end
P_final = L.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]));

% TURNS
T = [];
num_turns = 30000;
for i=1:num_turns
    L.set_nsteps(600);
    L.set_sc_nsteps(100);
    L.set_tt_nsteps(1);
    if (mod(i, 50) == 0)
    disp("Only SC")
        disp(i)
        disp(B1.get_info().sigma_t / RF_Track.ns * 2.355)
        disp(B1.get_info().emitt_y)
        T = [T; L.get_transport_table("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N")];
        save -ascii 'Results/transport_table_LATTICE_SC.dat' T
    end
    B1 = L.track(B0);
    B0 = B1;
end
