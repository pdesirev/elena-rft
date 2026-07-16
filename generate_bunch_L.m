addpath('/home/pdesirev/rf-track-2.1')
RF_Track;
%%%%%%% BEAM CHARACTERIZATION
N_particles = 10000; % number of macroparticles per bunch
P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
K = 0.1;
E = K + mass;
beta_rel = P_ref/E;

Q = -1; % antiprotons
charge = 5e7;
gemitt_x = 0.5; % Geometric emittance m
nemitt_x = gemitt_x * P_ref / mass; % Normalized emittance in m
FWHM = 150 * RF_Track.ns;
sigmat = FWHM / 2.355; % Gaussian approx
sigmapt = 0.2 % now it is not in any percentage

%% CHANGE OF UNITS TO PROPER RF-TRACK UNITS
T = Bunch6d_twiss();
T.emitt_x = nemitt_x; % mm.mrad == micron
T.emitt_y = nemitt_x; % mm.mrad == micron
T.sigma_t = sigmat; % mm/c
T.sigma_pt = sigmapt; % permil
% To be computed from the twiss table
T.beta_x = 1.770369896; % Actualized
T.beta_y = 2.691651829; % Actualized
T.alpha_x = 1.497350649e-14; % Actualized
T.alpha_y = 3.481504344e-16; % Actualized
T.disp_x = 68.779690;
T.disp_px = 1.776356839e-15;

B0 = Bunch6d(mass, charge, Q, P_ref, T, N_particles);
M = B0.get_phase_space();
% Gaussian buch
save -ascii 'Results/initial_particles_L.dat' M

