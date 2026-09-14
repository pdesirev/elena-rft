addpath('/home/pdesirev/rf-track-development')
RF_Track;
RF_Track_number_of_threads = 11;

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
        P = Pillbox_Cavity(20/l_rf, f_rf,l_rf, 1.0);
        P.set_phid(-90.0);
        A{i}.replace_with(P);
    end
    if l_rf == 0.0 
        A{i}.remove;
    end
end
P_final = L.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]))

L.append(Screen());

% TURNS
T = [];
num_turns = 60000;
for i=1:num_turns
    L.set_nsteps(60);
    L.set_tt_nsteps(1);
    if (mod(i, 50) == 0)
        disp("No effect")
        disp(i)
        disp(B1.get_info().sigma_t / RF_Track.ns * 2.355)
        disp(B1.get_info().emitt_y)
        % LOST PARTICLES
        Lo = L.get_lost_particles();
        Loss = [Loss; Lo];
        save -ascii 'Results/lost_particles_nothing.dat' Loss
        % TRANSPORT TABLE
        T = [T; L.get_transport_table("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N %beta_x %beta_y ")];
        save -ascii 'Results/transport_table_LATTICE_nothing.dat' T
        % PHASE SPACE
        Bunch = L.get_bunch_at_screens();
        M = Bunch{1}.get_phase_space();
        filename = sprintf('%s/screen_%05d.txt', 'Results', i);
        fid = fopen(filename, 'w');
        for k = 1:size(M,1)
            fprintf(fid, '%.18e %.18e %.18e %.18e %.18e %.18e\n', M(k,:));
        end
        fclose(fid);
    end
    B1 = L.track(B0);
    B0 = B1;
end
