classdef WindTurbineConstants < handle
    properties (Constant)
        sigma = 120*10^6; %limiting stress, PA
        rho_sw = 1025; %density of salt water, kg/m^3
        rho_st = 7810; %density of steel
        rho_b = 2400; %density of ballast, kg/m^3
        g = 9.82; %gravitational accel, m/s^2
        F = 1500*1000; %thrust, N
        towerheight = 120; %tower height, meters
        t_ma = 550*1000; %tower weight, kg
        r_n_g_ma = 660*1000; %rotor nacelle generator weight, kg
        cg_t = 65; %CoG of tower above the waterline
        k_moor = 70000; % N/m
    end
end