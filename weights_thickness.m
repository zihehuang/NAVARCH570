function [t1, t2, wt_cone, wt_ballast,wt_cyl,wt_trans,wt_bottom,...
    vol_cone,vol_ballast, vol_bottom, vol_cyl, vol_trans, height_ballast] = weights_thickness(D1, D2, T1, T2)
%This function takes in D1, D2, T1, T2 and calculates thicknesses t1 and
%t2.  Then calculates the wegith of the steel components and the weight of ballast
c = constants.WindTurbineConstants;

sigma = c.sigma; %limiting stress, PA
g = c.g; %gravitational accel, m/s^2
F = c.F; %thrust, F
H1 = T1+T2; %deepest point on cylinder
H2 = T2; %deepest point on cone
towerheight = c.towerheight; %tower height, m
R1 = D1./2;
R2 = D2./2;
t_ma = c.t_ma; %tower weight, kg
r_n_g_ma = c.r_n_g_ma; %rotor nacelle generator weight, kg 

%Thickness calc
t_h1 = c.rho_sw .* g .* D1 .* H1 ./ (2.*sigma); %hook stress t1 calc
t_h2 = c.rho_sw .* g .* D1 .* H2 ./ (2.*sigma); %hook stress t2 calc
t_b2 = F .* towerheight .* R2 ./ (pi .* (D2./2) .^3 .* sigma); %bending stress t1 calc
t1 = t_h1;
t2 = max(t_h2,t_b2);

%Uncomment this section to check with Collette's example
%{
t1 = 0.045 ; %example
t2 = 0.03 ; %example
sigma_h1 = c.rho_sw*g*D1*H1/(2*t1); %hook stress t1 calc
sigma_h2 = c.rho_sw*g*D1*H2/(2*t2); %hook stress t2 calc
sigma_b2 = F*towerheight*R2/(pi*(D2/2)^3*t2); %bending stress t1 calc
%}

%Surface Area calc
slant = sqrt((R1-R2).^2+T2.^2); %cone slant
sa_cone = pi.*(R1+R2).*slant; %cone walls surface area
sa_cyl = pi.*D1.*T1; %cylinder walls
sa_bottom = pi.*(R1).^2; %bottom surface area
sa_trans = pi.*D2.*10; %transition piece surface area

%Steel volume of individual pieces
vol_cone = sa_cone.*t2.*1.5;
vol_cyl = sa_cyl.*t1.*1.5;
vol_bottom = sa_bottom.*t1.*1.5;
vol_trans = sa_trans.*t2.*1.5;

%Weight of indidivual pieces
wt_cone = vol_cone .* c.rho_st .* g;
wt_cyl = vol_cyl .* c.rho_st .* g;
wt_bottom = vol_bottom .* c.rho_st .* g;
wt_trans = vol_trans .* c.rho_st .* g;

%Steel and Ballast mass calc
wt_tot = wt_cone+wt_cyl+wt_bottom+wt_trans;
vol_tot = wt_tot./(c.rho_st.*g); %for checking
vspar = pi.*R1.^2.*T1 +1/3.*pi.*T2.*(R1.^2+R1.*R2+R2.^2);
wt_ballast = vspar.*c.rho_sw.*g - wt_tot-t_ma.*g-r_n_g_ma.*g; 
vol_ballast = wt_ballast./(c.rho_b.*g);

%Height of Ballast
height_ballast = vol_ballast./(pi.*R1.^2);
end

