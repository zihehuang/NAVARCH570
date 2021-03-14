function[pitchoffset, naturalperiod] = dynamic_analysis(wt_tot, cog_total, cob_total, D1, D2, T1, T2, thickness1, thickness2, wt_ballast, cog_ballast, ht_ballast, wt_cone, wt_cyl, cog_cone, cog_cylinder)
c = constants.WindTurbineConstants;
kmoor = c.k_moor;
rhosw = c.rho_sw;
g = c.g;
turbine_mass = c.r_n_g_ma;
tower_mass = c.t_ma;
design_thrust = c.F;
towerheight = c.towerheight;

masstotal = wt_tot / g;

% please input all parameters in standard SI units
Iwp = pi/4*(D2/2)^4; % second area of waterplane
k33 = rhosw*g*Iwp - masstotal*g*cog_total + masstotal*g*cob_total + kmoor*cog_total^2; %lengthy k33 eq
k = [kmoor 0 kmoor*cog_total;
    0 (rhosw*g*pi*D2^2)/4 0;
    kmoor*cog_total 0 k33]; %k matrix
k_inv = inv(k);

pitchoffset_rad = k_inv(3,1)*design_thrust + k_inv(3,3)*design_thrust*towerheight; %pitch offset at steady state (0 acceleration)
pitchoffset = rad2deg(pitchoffset_rad);

% Calculating turbine moment of inertia about total CoG
Iturbine = turbine_mass*(towerheight-cog_total)^2; %turbine is point mass
Itower = tower_mass/3*(towerheight)^2 +tower_mass*(cog_total)^2; %tower is slender cylinder
Icone = 1/12*wt_cone*(3*(((D1+D2)/4)^2+((D1+D2)/4-thickness2)^2)+T2^2)+wt_cone*(cog_cone-cog_total)^2; %cone as hollow cylinder with diamter as average of D1 and D2
Icylinder = 1/12*wt_cyl*(3*((D1/2)^2+(D1/2-thickness1)^2)+T1^2)+wt_cyl*(cog_cylinder-cog_total)^2; % cylinder as hollow cylinder diameter D1
Iballast = 1/12*wt_ballast*(3*(D1/2)^2+ht_ballast^2) + wt_ballast*(cog_ballast-cog_total)^2; %ballast as solid cylinder, need how higher the ballast will go in the cylinder

ItotCoG = Iturbine + Itower + Icone + Icylinder + Iballast; % moment of inertia about total CoG
ItotWl = ItotCoG + masstotal*(cog_total)^2; % moment of inertia about waterline
Mdry = [masstotal 0 masstotal*cog_total; 0 masstotal 0; masstotal*cog_total 0 ItotWl]; %mass matrix

%added mass calcs
addedMass2DD1 = rhosw*pi*D1^2/4;
addedMass2DD2 = rhosw*pi*D2^2/4;
Madded11 = addedMass2DD1*(T1 + T2/2) + addedMass2DD2*(T2/2); %added mass at M11
Madded13 = addedMass2DD2*(T2/2)*(T2/4) + addedMass2DD1*(T2/2)*(3*T2/4)+addedMass2DD1*(T1/4)*((T2+T1/8)+(T2+3*T1/8)+(T2+5*T1/8)+(T2+7*T1/8)); % discretized added mass times moment arm
Madded33 = addedMass2DD2*(T2/2)*(T2/4)^2 + addedMass2DD1*(T2/2)*(3*T2/4)^2+addedMass2DD1*(T1/4)*((T2+T1/8)^2+(T2+3*T1/8)^2+(T2+5*T1/8)^2+(T2+7*T1/8)^2); %discretized added mass times moment arm squared
Madded = [Madded11 0 Madded13; 0 rhosw*g*pi*D1^3/12 0; Madded13 0 Madded33]; %added mass matrix
Mtotal = Mdry + Madded;
[V, D] = eig(k(2,2), Mtotal(2,2));
naturalperiod = (2*pi)./(D.^(0.5)); % heave natural period
end