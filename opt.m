function opt()
    lb = [35, 15, 35, 10];
    ub = [45, 25, 50, 25];
    [x,fval,exitflag,output] = particleswarm(@objective, 4, lb, ub);
end

function wt_final = objective(samples)
    D1 = samples(:,1);
    D2 = samples(:,2);
    T1 = samples(:,3);
    T2 = samples(:,4);
    
    if D1 <= 0 || D2 <= 0 || T1 <= 0 || T2 <= 0
        wt_final = inf;
    else
        [GM, pitch_vec, period_vec, wt_tot, wt_ballast, t1, t2] = Driver.calc_output(samples);
        
        penalty = 0;
        if t1 <= 0 || t2 <= 0
            penalty = inf;
        end
        if wt_ballast <= 0 || D2 > D1 || GM < 0 || pitch_vec > 8 || period_vec > 25
            penalty = inf;
        end
        wt_final = wt_tot + penalty;
    end
end