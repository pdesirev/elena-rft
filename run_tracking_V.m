clc
clear
RF_Track;

%% Gaussian bunch
%M = load('Results/initial_particles_V.dat');
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 5e7;

% Refererence particle
P_ref = 13.7; % MeV/c
E = hypot(mass, P_ref);
beta_rel = P_ref/E;

P0 = Bunch6dT(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]);
B0 = generate_bunch_V();

%% Load Lattice and set width / height
L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes
L.set_width(1.0);
L.set_height(0.2);

% Set halg gaps in SBends
for sb = L.get_sbends()
    sb{1}.set_hgap(0.05);
end

%% Setting up the Volume
V = Volume();
V.add (L, 0, 0, 0, reference='entrance');
V.set_aperture_y(0.2)
V.verbosity = 1;

% Integration options
V.odeint_algorithm = 'rk2';
V.odeint_epsabs = 1e-5;
V.t_max_mm = L.get_length() / beta_rel * 1e3; % just 1 turn to draw the reference trajectory
V.dt_mm = 10;
V.tt_dt_mm = 300;

% Track the reference particle to draw the reference orbit
V.track(P0);
T = V.get_transport_table("%mean_Z %mean_X %mean_Y %emitt_x %emitt_y %sigma_Z %N");

% Plot
clf
plot3 (T(:,1)/1e3, T(:,2)/1e3, T(:,3), 'linewidth', 2)
drawnow

% Track the bunch
V.t_max_mm = L.get_length() / beta_rel * 1e3 * 2;
V.tt_dt_mm = 0.0;
V.wp_basename = 'Results/ciao';
V.wp_dt_mm = V.t_max_mm / 100;

% Delete the existing files
system([ 'rm -f ' V.wp_basename '*.txt' ])

% Track
B1 = V.track(B0);
M1 = B1.get_phase_space();

% Plots
hold on
scatter3 (M1(:,5)/1e3, M1(:,1)/1e3, M1(:,3))

F = glob([ V.wp_basename '*.txt' ]);
for f = F'
    disp([ 'Reading ' f{1} '...' ]);
    M = load(f{1});
    scatter3 (M(:,5)/1e3, M(:,1)/1e3, M(:,3))
end

a = -66.117
l = 31.051
view(a,l)

xlabel('Z [m]')
ylabel('X [m]')
zlabel('Y [mm]')
grid on

print -dpng -S'800,600' -F:16 plot_coasting_beam.png 