RF_Track;

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

%% Load lattice
RCS = Lattice('elena.tws');
%RCS.set_width(1.0);
%RCS.set_height(0.1);

%% Place the lattice in Volume for time integration
V = Volume();
V.add (RCS, 0, 0, 0, reference='entrance');
V.dt_mm = 10;
V.set_s0 = 0.0;
%V.sc_dt_mm = 400;
V.tt_dt_mm = 1000;
V.t_max_mm = RCS.get_length() * 1e3 * 5/ beta_rel; % about 10 turns

%% Plot the field
xa = linspace(-10,  10, 1501); % m
za = linspace(-10, 10, 1500); % m
[X,Z] = ndgrid(xa*1e3,za*1e3); % mm
[E,B] = V.get_field (X(:), 0, Z(:), 0);
B(isnan(B)) = 0;

By = reshape(B(:,2), size(X)); % T

%figure(1)
%clf
%pcolor(za, xa, By)
%xlim([ min(za), max(za) ])
%ylim([ min(xa), max(xa) ])
%shading flat
%xlabel('Z [m]')
%ylabel('X [m]')
%daspect([ 1 1 ])
%shading flat

%%  Define a Bunch
M = load('Results/initial_particles_V.dat');
Q = -1; % antiprotons
charge = 1e7;
B0 = Bunch6dT(mass, charge, Q, M);


V.verbosity=2
B1 = V.track(B0);
T = V.get_transport_table('%mean_Z %mean_X %mean_P %emitt_x %emitt_y %emitt_4d %sigma_Z') / 1e3; % m
save -text transport_table.dat T
L = V.get_lost_particles();
save -text lost_particles.dat L