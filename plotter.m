e4d_nothing = load('Results/RFT_nemit_4d_nothing.dat');
e4d_all   = load('Results/RFT_nemit_4d_all.dat');
e4d_IBS = load('Results/RFT_nemit_4d_IBS.dat');
e4d_SC   = load('Results/RFT_nemit_4d_SC.dat');

mass = 938.27208943;
P_ref = 13.7;

e4g_nothing = e4d_nothing * mass / P_ref ;
e4g_all   = e4d_all * mass / P_ref ;
e4g_IBS = e4d_IBS * mass / P_ref ;
e4g_SC   = e4d_SC * mass / P_ref;

ex_nothing = load('Results/RFT_nemit_x_nothing.dat');
ex_all   = load('Results/RFT_nemit_x_all.dat');
ex_IBS = load('Results/RFT_nemit_x_IBS.dat');
ex_SC   = load('Results/RFT_nemit_x_SC.dat');


exg_nothing = ex_nothing * mass / P_ref;
exg_all   = ex_all * mass / P_ref ;
exg_IBS = ex_IBS * mass / P_ref ;
exg_SC   = ex_SC * mass / P_ref;

ey_nothing = load('Results/RFT_nemit_y_nothing.dat');
ey_all   = load('Results/RFT_nemit_y_all.dat');
ey_IBS = load('Results/RFT_nemit_y_IBS.dat');
ey_SC   = load('Results/RFT_nemit_y_SC.dat');


eyg_nothing = ey_nothing * mass / P_ref;
eyg_all   = ey_all * mass / P_ref;
eyg_IBS = ey_IBS * mass / P_ref ;
eyg_SC   = ey_SC * mass / P_ref;

bl_nothing = load('Results/RFT_bl_nothing.dat');
bl_all   = load('Results/RFT_bl_all.dat');
bl_IBS = load('Results/RFT_bl_IBS.dat');
bl_SC   = load('Results/RFT_bl_SC.dat');

figure(1);
h1 = plot(e4g_nothing, 'LineWidth', 2.0);
%h1 = plot(e4d_nothing/e4d_nothing(1), 'LineWidth', 2.0);
hold on;
%h2 = plot(e4d_IBS/e4d_IBS(1), 'LineWidth', 2.0);
h2 = plot(e4g_IBS, 'LineWidth', 2.0);
hold on
%h3 = plot(e4d_SC/e4d_SC(1), 'LineWidth', 2.0);
h3 = plot(e4g_SC, 'LineWidth', 2.0);
hold on
%h4 = plot(e4d_all/e4d_all(1), 'LineWidth', 2.0);
h4 = plot(e4g_all, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Geometric 4D Emittance [um]', 'FontSize', 20);
%ylabel('Relative 4D Emittance [mm * mrad]', 'FontSize', 20);
legend([h1 h2 h3 h4], ...
       'No IBS - No SC', ...
       'IBS', ...
       'SC', ...
       'IBS + SC', ...
       'FontSize', 20, ...
       'Location','southeast');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Non-linear = 0.');

figure(2);
%h1 = plot(ex_nothing/ex_nothing(1), 'LineWidth', 2.0);
h1 = plot(exg_nothing, 'LineWidth', 2.0);
hold on;
%h2 = plot(ex_IBS/ex_IBS(1), 'LineWidth', 2.0);
h2 = plot(exg_IBS, 'LineWidth', 2.0);
hold on
h3 = plot(exg_SC, 'LineWidth', 2.0);
%h3 = plot(ex_SC/ex_SC(1), 'LineWidth', 2.0);
hold on
%h4 = plot(ex_all/ex_all(1), 'LineWidth', 2.0);
h4 = plot(exg_all, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Hor. Emittance [um]', 'FontSize', 20);
%ylabel('Relative Hor. Emittance [mm * mrad]', 'FontSize', 20);
legend([h1 h2 h3 h4], ...
       'No IBS - No SC', ...
       'IBS', ...
       'SC', ...
       'IBS + SC', ...
       'FontSize', 20, ...
       'Location','southeast');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Non-linear = 0.');

figure(3);
%h1 = plot(ey_nothing/ey_nothing(1), 'LineWidth', 2.0);
h1 = plot(eyg_nothing, 'LineWidth', 2.0);
hold on;
%h2 = plot(ey_IBS/ey_IBS(1), 'LineWidth', 2.0);
h2 = plot(eyg_IBS, 'LineWidth', 2.0);
hold on
%h3 = plot(ey_SC/ey_SC(1), 'LineWidth', 2.0);
h3 = plot(eyg_SC, 'LineWidth', 2.0);
hold on
%h4 = plot(ey_all/ey_all(1), 'LineWidth', 2.0);
h4 = plot(eyg_all, 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Vert. Emittance [um]', 'FontSize', 20);
%ylabel('Relative Vert. Emittance [mm * mrad]', 'FontSize', 20);
legend([h1 h2 h3 h4], ...
       'No IBS - No SC', ...
       'IBS', ...
       'SC', ...
       'IBS + SC', ...
       'FontSize', 20, ...
       'Location','southeast');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Non-linear = 0.');

figure(4);
%h1 = plot(bl_nothing/bl_nothing(1), 'LineWidth', 2.0);
h1 = plot(bl_nothing, 'LineWidth', 2.0);
hold on;
h2 = plot(bl_IBS, 'LineWidth', 2.0);
%h2 = plot(bl_IBS/bl_IBS(1), 'LineWidth', 2.0);
hold on
h3 = plot(bl_SC, 'LineWidth', 2.0);
%h3 = plot(bl_SC/bl_SC(1), 'LineWidth', 2.0);
hold on
h4 = plot(bl_all, 'LineWidth', 2.0);
%h4 = plot(bl_all/bl_all(1), 'LineWidth', 2.0);
grid on;
set(gca, 'FontSize',20)
xlabel('Number of turns', 'FontSize', 20);
ylabel('Bunch length [ns]', 'FontSize', 20);

legend([h1 h2 h3 h4], ...
       'No IBS - No SC', ...
       'IBS', ...
       'SC', ...
       'IBS + SC', ...
       'FontSize', 20, ...
       'Location','southeast');

title('ELENA. P = 13.7 MeV/c. Antiprotons. Non-linear = 0.');