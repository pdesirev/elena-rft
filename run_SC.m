addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
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
B0 = Bunch6dT(mass, charge, Q, M);

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
    if strcmp(elname, 'LNR.ACWO2.0530')
        l_rf = A{i}.get_length();
        P = Pillbox_Cavity(0.0/l_rf, f_rf,l_rf, 1.0);
        P.set_phid(-90.0);
        A{i}.replace_with(P);
    end
 end
P_final = L.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]));

% TURNS
emitt_x = [];
emitt_y = [];
emitt_4d = [];
bunch_length = [];
T = [];
num_turns = 100;
for i=1:num_turns
    L.set_nsteps(100);
    L.set_sc_nsteps(30);
    disp(i)
    emitt_xi = B0.get_info().emitt_x;
    emitt_yi = B0.get_info().emitt_y;
    emitt_4di = B0.get_info().emitt_4d;
    bunch_lengthi = B0.get_info().sigma_t / RF_Track.ns;
    disp(emitt_4di)
    emitt_x = [emitt_x; emitt_xi];
    emitt_y = [emitt_y; emitt_yi];
    emitt_4d = [emitt_4d; emitt_4di];
    bunch_length = [bunch_length; bunch_lengthi];
    save -ascii 'Results/RFT_nemit_x_SC.dat' emitt_x
    save -ascii 'Results/RFT_nemit_y_SC.dat' emitt_y
    save -ascii 'Results/RFT_nemit_4d_SC.dat' emitt_4d
    save -ascii 'Results/RFT_bl_SC.dat' bunch_length
    %T = [T; L.get_transport_table("%S %emitt_x %emitt_y %sigma_t %N %beta_x %beta_y")];
    B1 = L.track(B0);
    B0 = B1;
end
