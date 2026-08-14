clc
clear
RF_Track;

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

%% Load lattice
RCS = Lattice('elena.tws');
RCS.set_width(15.0);
RCS.set_height(0.25);


A = RCS{'*'};
for i = 1:numel(A)
    l_rf = A{i}.get_length();
    if l_rf == 0.0 
        A{i}.remove;
    end
end

%% Place the lattice in Volume for time integration
V = Volume();
V.add (RCS, 0, 0, 0, reference='entrance');
V.odeint_algorithm = 'rkf45';
V.odeint_epsabs = 1e-5;
V.dt_mm = 10;
V.set_s0 = 0.0;
%V.sc_dt_mm = 400;
V.tt_dt_mm = RCS.get_length() * 1e3  * 0.1/ beta_rel;
V.t_max_mm = RCS.get_length() * 1e3  * 10/ beta_rel; % about 10 turns


%%  Define a Bunch
M = load('Results/initial_particles_V.dat');
Q = -1; % antiprotons
charge = 0.0;
B0 = Bunch6dT(mass, charge, Q, M);
%B0 = Bunch6dT(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]);

V.verbosity=2
B1 = V.track(B0);
T = V.get_transport_table('%mean_Z %mean_X %mean_Y %emitt_x %emitt_y %emitt_4d %sigma_Z') / 1e3; % m
save -text transport_table_TRACKING.dat T
L = V.get_lost_particles();
save -text lost_particles_TRACKING.dat L