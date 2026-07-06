addpath('/home/pdesirev/rf-track-2.1')
RF_Track;

% Gaussian buch
M = load('Results/initial_particles.dat');
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
h = 1 % up to 4 bunches
length = L.get_length();
c = 299792458;
f_rf = h * c * beta_rel / length;

A = L{'*'};
for i = 1:numel(A)
    elname = A{i}.get_name();
    if strcmp(elname, 'LNR.ACWO2.0530')
        A{i}.set_coefficients(20.0);
        A{i}.set_frequency(f_rf);
        A{i}.set_phid(-90.0);
        A{i}.set_t0(0.0);
    end
end

B_refp = Bunch6d(mass, charge, Q, [0.0, 0.0, 0.0, 0.0, 0.0, P_ref]);
B1 = L.track(B_refp); % checking if the reference particle gets lost
return
% TURNS
emitt_x = [];
emitt_y = [];
emitt_4d = [];
bunch_length = [];
T = [];
num_turns = 100;
for i=1:num_turns
    L.set_nsteps(100);
    B1 = L.track(B0);
    emitt_xi = B0.get_info().emitt_x;
    emitt_yi = B0.get_info().emitt_y;
    emitt_4di = B0.get_info().emitt_4d;
    bunch_lengthi = B0.get_info().sigma_t / RF_Track.ns;
    emitt_x = [emitt_x; emitt_xi];
    emitt_y = [emitt_y; emitt_yi];
    emitt_4d = [emitt_4d; emitt_4di];
    bunch_length = [bunch_length; bunch_lengthi];
    disp(i)
    disp(emitt_4di)
    save -ascii 'Results/RFT_nemit_x_nothing.dat' emitt_x
    save -ascii 'Results/RFT_nemit_y_nothing.dat' emitt_y
    save -ascii 'Results/RFT_nemit_4d_nothing.dat' emitt_4d
    save -ascii 'Results/RFT_bl_nothing.dat' bunch_length
    %T = [T; L.get_transport_table("%S %emitt_x %emitt_y %sigma_t %N %beta_x %beta_y")];
    B0 = B1;
end

