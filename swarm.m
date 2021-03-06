function swarm
clear all, close all
c = constants.WindTurbineConstants;

%particle swarm constants 
c1 = 1;
c2 = 1;
w = .5;

%variable ranges
D1 = [25, 45];
D2 = [10, 25];
T1 = [25; 50];
T2 = [5, 25];

%Swarm Creation
n = 1000;    %Number of particles in swarm
rD1 = rand(n,1).*(D1(2)-D1(1))+D1(1);
rD2 = rand(n,1).*(D2(2)-D2(1))+D2(1);
rT1 = rand(n,1).*(T1(2)-T1(1))+T1(1);
rT2 = rand(n,1).*(T2(2)-T2(1))+T2(1);

swarm =[rD1 rD2 rT1 rT2];
j = 0;
velo = ones(n,1);
%%iterate through generations checking converged condition
while max(std(swarm)) > .01
    j = j+1;%counter 
    
    [t1, t2, wt_cone, wt_ballast,wt_cyl,wt_trans,wt_bottom,...
        vol_cone,vol_ballast, vol_bottom, vol_cyl, vol_trans, ht_ballast] = ...
        weights_thickness(swarm(:,1),swarm(:,2),swarm(:,3),swarm(:,4));
    
    wt_st = wt_cone+wt_cyl+wt_bottom+wt_trans;
    %check this wt_tot in dynamic analysis
    wt_tot = wt_st +wt_ballast + c.t_ma*c.g +c.g*c.r_n_g_ma;
    
    cog_ballast = -(swarm(:,3)+swarm(:,4)-ht_ballast./2);
    [GM,VCG,VCB,VCG_cone,VCG_cyl] = gm_calculation(wt_bottom,wt_cyl,wt_trans,wt_cone,wt_ballast,...
        swarm(:,1),swarm(:,2),swarm(:,3),swarm(:,4),t1,t2);
    
    %Iterate through each particle
    for i = 1:size(swarm,1) 
        [pitchoffset, naturalperiod1, naturalperiod2, naturalperiod3] = dynamic_analysis(wt_tot(i,:), VCG(i,:),...
            VCB(i,:), swarm(i,1),swarm(i,2),swarm(i,3),swarm(i,4), t1(i,:), t2(i,:), wt_ballast(i,:),...
            cog_ballast(i,:), ht_ballast(i,:), wt_cone(i,:), wt_cyl(i,:), VCG_cone(i,:),VCG_cyl(i,:));
        
        
        %Check if boundary conditions are violated element by element
        if naturalperiod1 <=25 || naturalperiod2<=25 ||naturalperiod3<=25|| pitchoffset > 8 || GM(i)<=0 || wt_ballast(i)<0 ||...
            swarm(i,1) <D1(1) || swarm(i,2) <D2(1) || swarm(i,3) <T1(1) || swarm(i,4) <T2(1)
            cost(i,1) = 25000000;
        else %if boundary conditions are not violated, set cost to function
            cost(i,1) = (wt_st(i,:) + .05*wt_ballast(i,:))./c.g;
        end 
        
        if j == 1
            cost_pbest(i,1) = cost(i,1); %initialize personal best cost 
            pbest(i,:) = swarm(i,:); % initialize personal best T1 T2 D1 D2
        elseif cost(i,1) < cost_pbest(i,1) % check if new cost is less than personal best
            pbest(i,:) = swarm(i,:); %set new personal best location
            cost_pbest(i,:) = cost(i,1); %set new personal best cost
        end
    end
    
    if j == 1 %generation one
        velo = zeros(n,4); %initialize velocities to zero
        [cost_gbest,ind] = min(cost); %initialize group best cost
        gbest = swarm(ind,:); % initialize group best location
    elseif min(cost) < cost_gbest % all other gens: check is new group cost is less than group best
        [cost_gbest,ind] = min(cost); %set new group best cost
        gbest = swarm(ind,:); %set new group best location
    end
    
    %Plot each swarm generation on the same 3D scatter plot
    scatter3(swarm(:,1).*swarm(:,3), swarm(:,2).*swarm(:,4), cost(:,1))
    hold on
    
    r1 = rand(1);
    r2 = rand(1);
    %velocity and position updating for swarm
    velo = w.*velo + c1.*r1.*(pbest - swarm)+c2.*r2.*(gbest - swarm);
    swarm = swarm + velo;
    tracker(j,:) = max(velo);
end

%Output final global optimum dimensions and related cost
display('***************************************************************************************************')
display('The final global optimum dimension matrix in the form of [D1 D2 T1 T2] is:')
Final_Gbest = gbest
display('The cost of the global optimum construction is:')
Final_Cost = cost_gbest

%Add G_best marker to 3D scatter plot, change marker characteristics to highlight location
scatter3(gbest(1,1)*gbest(1,3),gbest(1,2)*gbest(1,4),cost_gbest(1,1),'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
title('Scatter Plot of Spar Cost Over the Design Space')
xlabel('D1*T1')
ylabel('D2*T2')
zlabel('Cost')
hold off
end
