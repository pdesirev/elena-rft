RF_Track;
tt_nothing = load('Results/transport_table_LATTICE_nothing.dat');
tt_all   = load('Results/transport_table_LATTICE_all.dat');
tt_SC   = load('Results/transport_table_LATTICE_SC_20kicks.dat');
tt_SC_3kicks   = load('Results/transport_table_LATTICE_SC_100kicks.dat');
tt_IBS   = load('Results/transport_table_LATTICE_IBS.dat');

%("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N")];

mass = 938.27208943;
P_ref = 13.7;
K = 0.1;
E = sqrt(P_ref^2 + mass^2);
beta_rel = P_ref/E;

time_turn = 30.405 / (beta_rel * 299792458) * 1e3; % in milsec


S_nothing = tt_nothing(:,1) / 30.405; % number of turns 
S_all = tt_all(:,1) / 30.405; % number of turns 
S_SC = tt_SC(:,1)  / 30.405; % number of turns 
S_SC_3kicks = tt_SC_3kicks(:,1)  / 30.405; % number of turns 
S_IBS = tt_IBS(:,1)  / 30.405; % number of turns 

time_nothing = S_nothing * time_turn; % number of turns 
time_all = S_all * time_turn; % number of turns 
time_SC = S_SC  * time_turn; % number of turns 
time_SC_3kicks = S_SC_3kicks  * time_turn; % number of turns 
time_IBS = S_IBS  * time_turn; % number of turns 


%bl_nothing = tt_nothing(:,6) * beta_rel;
%bl_all = tt_all(:,6) * beta_rel;
%bl_SC = tt_SC(:,6) * beta_rel;

bl_nothing = tt_nothing(:,6) / RF_Track.ns * 2.355;
bl_all = tt_all(:,6) / RF_Track.ns * 2.355;
bl_SC = tt_SC(:,6) / RF_Track.ns * 2.355;
bl_IBS = tt_IBS(:,6) / RF_Track.ns * 2.355;

eyg_nothing = tt_nothing(:,3) * mass / P_ref;
eyg_all = tt_all(:,3) * mass / P_ref;
eyg_SC = tt_SC(:,3) * mass / P_ref;
eyg_IBS = tt_IBS(:,3) * mass / P_ref;

%sy_nothing = tt_nothing(:,12);
%sy_all = tt_all(:,12);
sy_SC = tt_SC(:,12);
sy_SC_3kicks = tt_SC_3kicks(:,12); % number of turns 
%sy_IBS = tt_IBS(:,12);

figure(1);
hold on;
h1 = plot(S_nothing, eyg_nothing, 'LineWidth', 2.0);
h2 = plot(S_SC, eyg_SC, 'LineWidth', 2.0);
%h3 = plot(S_all, eyg_all, 'LineWidth', 2.0);
%h4 = plot(S_IBS, eyg_IBS, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Geometric Vertical Emittance [um]', 'FontSize', 20);
legend([h1, h2], ...
       'No IBS - No SC', ...
       'SC', ...
       %'IBS + SC', ...
       %'IBS', ...
       'FontSize', 20, ...
       'Location','northwest');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Bunched beam');

figure(2);
clf;
hold on;

h1 = plot(S_nothing, bl_nothing, 'LineWidth', 2.0);
h2 = plot(S_SC, bl_SC, 'LineWidth', 2.0);

grid on;
set(gca, 'FontSize',20)

xlabel('Number of turns', 'FontSize', 20);
ylabel('FWHM Bunch length [ns]', 'FontSize', 20);

legend([h1, h2], ...
       'No IBS - No SC', ...
       'SC', ...
       'FontSize', 20, ...
       'Location','northwest');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Bunched beam');

figure(3);
hold on;
%h1 = plot(11150 + time_nothing, sy_nothing, 'LineWidth', 2.0);
h2 = plot(11150 + time_SC, sy_SC, 'LineWidth', 2.0);
h3 = plot(11150 + time_SC_3kicks, sy_SC_3kicks, 'LineWidth', 2.0);
%h3 = plot(11150 + time_all, sy_all, 'LineWidth', 2.0);
%h4 = plot(11150 + time_IBS, sy_IBS, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Time [ms]', 'FontSize', 20);
ylabel('Sigma y [mm]', 'FontSize', 20);
legend('20 kicks per turn','3 kicks per turn')
title('With SC');
