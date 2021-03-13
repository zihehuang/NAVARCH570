function main()
    c = constants.WindTurbineConstants;
    D1 = [10, 20];
    D2 = [4, 8];
    T1 = [20, 40];
    T2 = [10, 20];
    coded = ccdesign(4, 'center', 1);
    samples = convertValues([D1; D2; T1; T2], coded);
    
    [t1, t2, wt_cone, wt_ballast,wt_cyl,wt_trans,wt_bottom,...
    vol_cone,vol_ballast, vol_bottom, vol_cyl, vol_trans] = ...
        weights_thickness(samples(:,1),samples(:,2),samples(:,3),samples(:,4));
    disp(wt_cone)
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
        avg = mean([min_orig max_orig]);
        half_range = (max_orig - min_orig) / 2;
        samples(:,i) = (coded + 1) .* half_range + min_orig;
    end
    samples(samples(:,2) > samples(:,1), :) = []; % D2 cant be greater than D1
end
