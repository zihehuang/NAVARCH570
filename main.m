function main()
    D1_limit = [20, 30];
    D2_limit = [4, 8];
    T1_limit = [35, 40];
    T2_limit = [15, 20];
    coded = ccdesign(4, 'center', 1);
    samples = convertValues([D1_limit; D2_limit; T1_limit; T2_limit], coded);
    D1 = samples(:,1);
    D2 = samples(:,2);
    T1 = samples(:,3);
    T2 = samples(:,4);

    [t1, t2, wt_cone, wt_ballast,wt_cyl,wt_trans,wt_bottom,...
    vol_cone,vol_ballast, vol_bottom, vol_cyl, vol_trans, ht_ballast] = ...
        weights_thickness(D1,D2,T1,T2);
    wt_tot = wt_cone+wt_cyl+wt_bottom+wt_trans;
    cog_ballast = -(T1+T2-ht_ballast./2);
    [GM,VCG,VCB] = gm_calculation(wt_bottom,wt_cyl,wt_trans,wt_cone,wt_ballast,...
        T1,T2,D1,D2,t1,t2);
    
    pitch_vec = zeros(size(samples,1),1);
    period_vec = zeros(size(samples,1),1);
    for i = 1:size(samples,1)
        [pitchoffset, period] = dynamic_analysis(wt_tot(i,:), VCG(i,:),...
		VCB(i,:), samples(i,1), samples(i,2), samples(i,3),...
		samples(i,4), t1(i,:), t2(i,:), wt_ballast(i,:),...
		cog_ballast(i,:), ht_ballast(i,:), wt_cone(i,:), wt_cyl(i,:), 0, 0);
    
        pitch_vec(i,:) = pitchoffset;
        period_vec(i,:) = period;
    end
    
    wt_cone
    GM
    pitch_vec
    period_vec
end

% for each column in the coded level matrix
% convert coded level to actual level
function samples = convertValues(all_levels, all_coded)
    [m, n] = size(all_coded);
    samples = zeros(m,n);
    for i = 1:n
        levels = all_levels(i,:);
        coded = all_coded(:,i);
        min_orig = min(levels);
        max_orig = max(levels);
        half_range = (max_orig - min_orig) / 2;
        samples(:,i) = (coded + 1) .* half_range + min_orig;
    end
    samples(samples(:,2) > samples(:,1), :) = []; % D2 cant be greater than D1
end
