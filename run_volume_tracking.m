RF_Track;

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

%% Load lattice
RCS = Lattice('elena.tws');
RCS.set_width(1.0);
RCS.set_height(0.1);

%% Place the lattice in Volume for time integration
V = Volume();
V.add (RCS, 0, 0, 0);
V.dt_mm = 10;
%V.sc_dt_mm = 400;
V.tt_dt_mm = 1000;
V.t_max_mm = RCS.get_length() * 1e3 / beta_rel; % about 10 turns

%% Plot the field
xa = linspace(-10,  10, 1501); % m
za = linspace(-10, 10, 1500); % m
[X,Z] = ndgrid(xa*1e3,za*1e3); % mm
[E,B] = V.get_field (X(:), 0, Z(:), 0);
B(isnan(B)) = 0;

By = reshape(B(:,2), size(X)); % T

figure(1)
clf
pcolor(za, xa, By)
xlim([ min(za), max(za) ])
ylim([ min(xa), max(xa) ])
shading flat
xlabel('Z [m]')
ylabel('X [m]')
daspect([ 1 1 ])
shading flat

%%  Define a Bunch
M = load('Results/initial_particles.dat');
Q = -1; % antiprotons
charge = 1e7;
B0_ = Bunch6d(mass, charge, Q, M);

P0 = Bunch6dT(mass, charge, Q, [ 0 0 0 0 0 P_ref ]);
B0 = Bunch6dT(B0_);

if 0
    %% Tracking
    V.verbosity = 2;
    tic
    B1 = V.track(B0);
    toc
    M1 = B1.get_phase_space();
    figure(1)
    hold on
    scatter(M1(:,5)/1e3, M1(:,1)/1e3, 10, 'o')
    figure(2);
    plot(V.get_transport_table('%emitt_6d'))
    T = V.get_transport_table('%t %mean_X %mean_Y %mean_Z %sigma_X %sigma_Y %sigma_Z %emitt_x %emitt_y %emitt_z %emitt_6d');
    save -text transport_table.dat T
else
    %% Track and plot trajectories
    figure(1)
    hold on
    for n=1:1
        %P0_ = P0.displaced (0.1*randn, 0.1*randn, 0.0);
        P0_ = P0;
        V.track(P0);
        T = V.get_transport_table('%mean_Z %mean_X') / 1e3; % m
        save -text transport_table.dat T
        %% Plot
        plot(T(:,1), T(:,2))
        drawnow
    end
end