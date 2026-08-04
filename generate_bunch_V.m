function B0T = generate_bunch_V()
RF_Track;
%%%%%%% BEAM CHARACTERIZATION
N_particles = 1000; % number of macroparticles per bunch
P_ref = 13.7; % MeV/c
mass = RF_Track.protonmass;
Q = -1; % antiprotons
E = hypot(mass, P_ref);
beta_rel = P_ref/E;

charge = 5e7;
gemitt_x = 0.5; % Geometric emittance m
nemitt_x = gemitt_x * P_ref / mass % Normalized emittance in m
FWHM = 150 * RF_Track.ns;
sigmat = FWHM / 2.355; % Gaussian approx
sigmapt = 0.2 % now it is not in any percentage

%% CHANGE OF UNITS TO PROPER RF-TRACK UNITS
T = Bunch6d_twiss();
T.emitt_x = 0*nemitt_x; % mm.mrad == micron
T.emitt_y = 0*nemitt_x; % mm.mrad == micron
T.sigma_t = 0*sigmat; % mm/c
T.sigma_pt = sigmapt; % permil
% To be computed from the twiss table
T.beta_x = 1.77828956; % Actualized
T.beta_y = 2.68096546; % Actualized
T.alpha_x = -0.0006845884036; % Actualized
T.alpha_y = -0.003980352848; % Actualized
T.disp_x = 68.779690;
T.disp_px = 0.002245030523;
T.disp_y = -1.554330053;
T.disp_py = -0.6858304775;

B0 = Bunch6d_QR (mass, charge, Q, P_ref, T, N_particles, 2);
B0T = Bunch6dT(B0);