addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
SC = SC = SpaceCharge_PIC_FreeSpace(32, 32, 32);
RF_Track.SC_engine = SC;

%%%%%%% BEAM CHARACTERIZATION
N_particles = 10000; % number of macroparticles per bunch
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 1e7;

% Gaussian buch
M = load('Results/initial_particles.dat');
B0 = Bunch6d(mass, charge, Q, M);

% ALWAYS CHECK THAT THE TWISS FILE WAS GENERATED WITH THE GOOD PARAMETERS
% acc-models-elena/scenarios/highenergy.beam -- change if needed
L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes

% TURNS
emitt_x = [];
emitt_y = [];
emitt_4d = [];
bunch_length = [];
T = [];
num_turns = 100;
for i=1:num_turns
    L.set_nsteps(100);
    L.set_sc_nsteps(20);
    B1 = L.track(B0);

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
    B0 = B1;
end
