RF_Track;
tt_nothing = load('Results/transport_table_LATTICE_nothing.dat');
tt_all   = load('Results/transport_table_LATTICE_all.dat');
tt_SC   = load('Results/transport_table_LATTICE_SC.dat');

%("%S %emitt_x %emitt_y %emitt_4d %mean_t %sigma_t %mean_P %N")];

mass = 938.27208943;
P_ref = 13.7;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

S_nothing = tt_nothing(:,1) / 30.405; % number of turns 
S_all = tt_all(:,1) / 30.405; % number of turns 
S_SC = tt_SC(:,1)  / 30.405; % number of turns 


%bl_nothing = tt_nothing(:,6) * beta_rel;
%bl_all = tt_all(:,6) * beta_rel;
%bl_SC = tt_SC(:,6) * beta_rel;

bl_nothing = tt_nothing(:,6) / RF_Track.ns * 2.355;
bl_all = tt_all(:,6) / RF_Track.ns * 2.355;
bl_SC = tt_SC(:,6) / RF_Track.ns * 2.355;

eyg_nothing = tt_nothing(:,3) * mass / P_ref;
eyg_all = tt_all(:,3) * mass / P_ref;
eyg_SC = tt_SC(:,3) * mass / P_ref;

figure(1);
hold on;
h1 = plot(S_nothing, eyg_nothing, 'LineWidth', 2.0);
h2 = plot(S_SC, eyg_SC, 'LineWidth', 2.0);
% h3 = plot(S_all, eyg_all, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Geometric Vertical Emittance [um]', 'FontSize', 20);
legend([h1 h2], ...
       'No IBS - No SC', ...
       'SC', ...
    %   'IBS + SC', ...
       'FontSize', 20, ...
       'Location','northwest');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Bunched beam');

figure(2);
hold on;
h2 = plot(S_SC, bl_SC, 'LineWidth', 2.0);
h1 = plot(S_nothing, bl_nothing, 'LineWidth', 2.0);
%h3 = plot(S_all, bl_all, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('FWHZ Bunch length [ns]', 'FontSize', 20);
legend([h2 h1], ...
       'SC', ...
       'No IBS - No SC', ...
  %     'IBS + SC', ...
       'FontSize', 20, ...
       'Location','northwest');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Bunched beam');
