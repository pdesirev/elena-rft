addpath('/home/pdesirev/rf-track-development')
RF_Track;
RF_Track_number_of_threads = 8;
SC = SpaceCharge_PIC_FreeSpace(32,32,32);
SC.set_smooth(0.5); % SC - set smooth facto
RF_Track.SC_engine = SC;

%%%%%%% BEAM CHARACTERIZATION
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
%M = load('Results/initial_particles_sc.dat');
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
        P = Pillbox_Cavity(20/l_rf, f_rf,l_rf, 1.0);
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
num_turns = 300;

% Folder for frames
mkdir('phase_space_frames');
M0 = B0.get_phase_space();

t0 = M0(:,5);
p0 = M0(:,6);

dt0 = t0 - mean(t0);
dp0 = (p0 - mean(p0)) ./ mean(p0) * 1e3;

x_lim = 6 * std(dt0);
y_lim = 6 * std(dp0);
figure(1);

T = [];
PS = cell(num_turns, 1);

% ============================================================
% FIXED AXES FROM INITIAL BUNCH
% ============================================================

M0 = B0.get_phase_space();

t0 = M0(:,5);
p0 = M0(:,6);

dt0 = t0 - mean(t0);
dp0 = (p0 - mean(p0)) ./ mean(p0) * 1e3;

% Give enough room for SC growth
x_lim = 10 * std(dt0);
y_lim = 10 * std(dp0);

for i = 1:num_turns

    disp(i)
    L.set_nsteps(60);
    L.set_sc_nsteps(10);
    L.set_tt_nsteps(1);
    B1 = L.track(B0);
    % Store complete phase space
    PS{i} = B1.get_phase_space();
    filename = sprintf('phase_space_frames/SC_%04d.dat', i);
    dlmwrite(filename, PS{i}, 'delimiter', ' ', 'precision', '%.16e');
    
    
    T = [T; L.get_transport_table( ...
        "%S %emitt_x %emitt_y %sigma_x %sigma_y %beta_x %beta_y")];
    B0 = B1;

end


%%%%%%%%%%%%%%%%%%%%%% no sc
L0 = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes

A = L0{'*'};
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

P_final = L0.autophase(Bunch6d(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]));
B0no = Bunch6d(mass, charge, Q, M);
num_turns = 300;
Tno = [];
for i=1:num_turns
    L0.set_nsteps(60);
    L0.set_tt_nsteps(1);
    B1no = L0.track(B0no);
    B0no = B1no;
    Tno = [Tno; L0.get_transport_table("%S %emitt_x %emitt_y %sigma_x %sigma_y %beta_x %beta_y")];
end

M1 = B1.get_phase_space();      % SC
M2 = B1no.get_phase_space();    % No SC

%save -ascii 'Results/initial_particles_sc.dat' M1

figure(4)
plot(T(:,1), T(:,3))
hold on
plot(Tno(:,1), Tno(:,3))
hold on
plot(T(:,1), T(:,2))
hold on
plot(Tno(:,1), Tno(:,2))
legend('emitt y - SC', 'emitt y - nothing', 'emitt x - SC', 'emitt x - nothing', 'FontSize', 20)
set(gca, 'FontSize', 20)
ylabel('Emitt[m]', 'FontSize', 20)
xlabel('S [m]', 'FontSize', 20)

figure(5)
plot(T(:,1), T(:,4))
hold on
plot(Tno(:,1), Tno(:,4))
hold on
plot(T(:,1), T(:,5))
hold on
plot(Tno(:,1), Tno(:,5))
grid on
set(gca, 'FontSize', 20)
ylabel('Sigma [m]', 'FontSize', 20)
xlabel('S [m]', 'FontSize', 20)
legend('sigma x - SC', 'sigma x  - nothing', 'sigma y - SC', 'sigma y - nothing', 'FontSize', 20)