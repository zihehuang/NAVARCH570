function [GM,VCG,VCB,VCG_cone,VCG_cyl] = gm_calculation(wt_bottom,wt_cyl,w_trans,wt_cone,wt_ballast,T1,T2,D1,D2,t1,t2)
%GM calculator - NA 570 - Winter 2021 - Wind tubine project
%  Function to calculate the GM values for the variations of T1, T2, D1
%  D2, t1, t2. This function finds the vertical center of gravity (VCG),
%  Vertical center of boyancy (VCB) and the distance from the VCB to the
%  metacenter (BM). These values are used to calculate the GM. GM is used
%  to understand stability characteristics

%% Constants
c = constants.WindTurbineConstants;
rho_sw = c.rho_sw; %density of salt water, kg/m^3
rho_b = c.rho_b; %density of ballast, kg/m^3
g = c.g; %gravitational accel, m/s^2

m_tower = c.t_ma; %Mass of tower in kg
cg_t = c.cg_t;          %CoG of tower above the waterline

m_rna = c.r_n_g_ma;   %Mass of rotor nacelle assy in kg
cg_r = c.towerheight;         %CoG of rotor nacelle assy above the waterline

r1 = D1/2;   %Radius 1
r2 = D2/2;   %Radius 2

%% Height of concrete and draft volume
H_concrete = (wt_ballast/(rho_b*g))./(pi*((r1-t1).^2)); %Height of concrete ballast in base
V_draft = pi*r1.^2.*T1 + 1/3*pi*T2.*(r1.^2+r1.*r2+r2.^2); %Volume of the spar

%% VCG, VCB, and GM

VCG_cyl = -(T2+(T1/2));

WM_flat = (wt_bottom/g).*(-(T1+T2));      %Weight Moment of steel - bottom flat plate
WM_base = (wt_cyl/g).*(-(T2+(T1/2)));  %Weight Moment of steel - base cylinder
WM_tip = (w_trans/g)*5;                 %Weight Moment of steel - top cylinder

VCG_cone = ((pi*(2*r2+r1).*sqrt(((r1-r2).^2).*(T2.^2)+(T2.^4)))/3)./(pi*(r1+r2).*sqrt(((r1-r2).^2)+(T2.^2)));  %Center of area for cone
WM_cone = (wt_cone/g).*(VCG_cone-T2);      %Weight Moment of steel - cone

WM_total = WM_flat + WM_base + WM_tip + WM_cone + (m_tower*cg_t) + (m_rna*cg_r) + (wt_ballast/g).*((-T2-T1)+(H_concrete/2));

VCG = WM_total./(V_draft*rho_sw);    %Vertical Center of Gravity

Z_cone = (T2.*((r1.^2)+(2*r1.*r2)+3*(r2.^2)))./(4*((r1.^2)+(r1.*r2)+(r2.^2))); %Vertical Center of Boyancy of the Cone from cone base 
VCB_cone = (Z_cone-T2);  %Vertical Center of Boyancy of the Cone from waterline

VCB_mom = (pi*(r1.^2)).*T1.*(-T2-(T1/2))+((pi/3)*T2).*((r1.^2)+(r1.*r2)+(r2.^2)).*(Z_cone-T2);

VCB = VCB_mom./V_draft;    %Vertical center of boyancy

BM = ((pi/4)*(r2.^4))./V_draft;  %Center of boyancy to metacenter

GM = VCB + BM - VCG;
end



