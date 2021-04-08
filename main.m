function main()
    D1_limit = [35, 45];
    D2_limit = [15, 25];
    T1_limit = [35, 50];
    T2_limit = [10, 25];
    coded = ccdesign(4, 'center', 1);

    samples = Driver.convert_values([D1_limit; D2_limit; T1_limit; T2_limit], coded);
    
    [GM, pitch_vec, period_vec, wt_tot] = Driver.calc_output(samples);
    
    Driver.do_regression(samples, GM, pitch_vec, period_vec, wt_tot);
end

