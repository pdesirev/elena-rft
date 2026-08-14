addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
RF_Track_number_of_threads = 8;
IBS = IntraBeamScattering (32,32,32, 200);

%%%%%%% BEAM CHARACTERIZATION
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 1e7;
% Gaussian buch
M = load('Results/initial_particles_L.dat');
B0 = Bunch6d(mass, charge, Q, M);
P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

% ALWAYS CHECK THAT THE TWISS FILE WAS GENERATED WITH THE GOOD PARAMETERS
% acc-models-elena/scenarios/highenergy.beam -- change if needed
L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes
h = 4 % up to 4 bunches
length = L.get_length();
c = 299792458;
f_rf = h * c * beta_rel / length;
A = L{'*'};

% The solenoids are giving problems!!!
% UPDATE: Together with the rfcavity, I have changed it for a drift
for i = 1:numel(A)
    elname = A{i}.get_name();
    if strcmp(elname, 'LNR.ACWO2.0530')
        l_rf = A{i}.get_length();
        P = Pillbox_Cavity(12.0/l_rf, f_rf,l_rf, 1.0);
        P.set_phid(-90.0);
        A{i}.replace_with(P);
    end
 end

P_final = L.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]))

% TURNS
T = [];
num_turns = 30000;
L.add_collective_effect(IBS);
for i=1:num_turns
    L.set_nsteps(600);
    L.set_cfx_nsteps(100);
    L.set_tt_nsteps(1);
    if (mod(i, 50) == 0)
        disp("Only IBS")
        disp(i)
        disp(B1.get_info().sigma_t / RF_Track.ns * 2.355)
        disp(B1.get_info().emitt_y)
        T = [T; L.get_transport_table("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N")];
        save -ascii 'Results/transport_table_LATTICE_IBS.dat' T
    end
    B1 = L.track(B0);
    B0 = B1;
end
