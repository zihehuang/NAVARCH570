close all; clear all, clc;

D1 = [20 20; 20 20; 30 30; 30 30];
D2 = [8 8; 10 10; 8 8; 10 10];
T1 = [35 40; 35 40; 35 40; 35 40];
T2 = [15 20; 15 20; 15 20; 15 20;];

sigma = 120*10^6; %limiting stress, PA
rho_sw = 1025; %density of salt water, kg/m^3
rho_st = 7810; %density of steel
rho_b = 2400; %density of ballast, kg/m^3
g = 9.82; %gravitational accel, m/s^2
H1 = T1+T2; %deepest point on cylinder
H2 = T2; %deepest point on cone
F = 1500*1000; %thrust, N
towerheight = 120; %tower height, m
R1 = D1/2;
R2 = D2/2;
t_ma = 550*1000; %tower weight, kg
r_n_g_ma = 660*1000; %rotor nacelle generator weight, kg 

%Thickness calc
t_h1 = rho_sw*g.*D1.*H1/(2*sigma); %hoop stress t1 calc
t_h2 = (rho_sw*g*D1.*H2)/(2*sigma); %hoop stress t2 calc
t_b2 = (F*towerheight*R2)./(pi*((D2/2).^3)*sigma); %bending stress t1 calc
t1 = t_h1;
t2 = max(t_h2,t_b2);

%Uncomment this section to check with Collette's example
%{
t1 = 0.045 ; %example
t2 = 0.03 ; %example
sigma_h1 = rho_sw*g*D1*H1/(2*t1); %hook stress t1 calc
sigma_h2 = rho_sw*g*D1*H2/(2*t2); %hook stress t2 calc
sigma_b2 = F*towerheight*R2/(pi*(D2/2)^3*t2); %bending stress t1 calc
%}

%Surface Area calc
slant = sqrt((R1-R2).^2+T2.^2); %cone slant
sa_cone = pi*(R1+R2).*slant; %cone walls surface area
sa_cyl = pi*D1.*T1; %cylinder walls
sa_bottom = pi*(R1).^2; %bottom surface area
sa_trans = pi*D2*10; %transition piece surface area

%Steel volume of individual pieces
vol_cone = sa_cone.*t2;
vol_cyl = sa_cyl.*t1;
vol_bottom = sa_bottom.*t1;
vol_trans = sa_trans.*t2;

%Weight of indidivual pieces
wt_cone = vol_cone*rho_st*g;
wt_cyl = vol_cyl*rho_st*g;
wt_bottom = vol_bottom*rho_st*g;
wt_trans = vol_trans*rho_st*g;

%Steel and Ballast mass calc
wt_tot = (wt_cone+wt_cyl+wt_bottom+wt_trans)*1.5;
vol_tot = wt_tot/(rho_st*g); %for checking
vspar = pi*R1.^2.*T1 + 1/3*pi*T2.*(R1.^2+R1.*R2+R2.^2);
wt_ballast = vspar*rho_sw*g - wt_tot-t_ma*g-r_n_g_ma*g; 
vol_ballast = wt_ballast/(rho_b*g);

%% GM Calculation

[GM, VCG, VCB] = GM_Calc(wt_bottom,wt_cyl,wt_trans, wt_cone,wt_ballast,T1,T2,D1,D2,t1,t2); 
GM
