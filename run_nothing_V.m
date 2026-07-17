clc
clear
addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
RF_Track.number_of_threads = 1;

% Gaussian buch
M = load('Results/initial_particles_V.dat');
mass = RF_Track.protonmass;
Q = -1; % antiprotons
charge = 5e7;
%B0 = Bunch6dT(mass, charge, Q, M);
clear M

P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

B0 = Bunch6dT(RF_Track.protonmass, 0.0, -1, [ 0 0 0 0 0 P_ref ]);
%L = Lattice("elena.tws"); % To be generated with the notebook. Adapt the magnitudes

V = Volume();
V.odeint_algorithm = 'analytic';
%V.add(L, 0.0, 0.0, 0.0, reference='entrance');
Bx_struct = load('Bx.dat');
Bx = Bx_struct.Bx;
disp('after Bx')
clear Bx_struct
By_struct = load('By.dat');
By = By_struct.By;
clear By_struct
disp('after By')
Bz_struct = load('Bz.dat');
Bz = Bz_struct.Bz;
clear Bz_struct 
disp('after Bz')

xa = load('xa.dat','-ascii');
ya = load('ya.dat','-ascii');
za = load('za.dat','-ascii');
x0 = xa(1);
y0 = ya(1);
z0 = za(1);
hx = xa(2)-xa(1);
hy = ya(2)-ya(1);
hz = za(2)-za(1);
Lmap = za(end)-za(1);
clear za
disp("before")
system("ps -o pid,rss,vsz,cmd -C octave-gui")
Bfield = Static_Magnetic_FieldMap(...
    Bx, By, Bz,...
    x0, y0,...
    hx, hy, hz,
    Lmap);
disp("after")
system("ps -o pid,rss,vsz,cmd -C octave-gui")

disp('after Static_Magnetic_FieldMap')
V.add(Bfield, 0.0, 0.0, z0, 'entrance');

V.verbosity = 1;
V.t_max_mm = 30.405 / beta_rel *1e3 * 50;
V.dt_mm = 100;
V.tt_dt_mm = 3000;
%V.wp_dt_mm = V.get_length() * 10/ beta_rel *1e3;
%V.wp_basename = 'Results/ps_nothing'
B1 = V.track(B0);
T = V.get_transport_table("%mean_Z %mean_X %mean_Y %emitt_x %emitt_y %sigma_Z %N");
save -text Results/transport_table_nothing.dat T

