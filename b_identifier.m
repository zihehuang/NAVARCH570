function[sig_b_index, sig_X_fit] = b_identifier(b_val, X_fit, sigmasq)
%input, b_val (11 item vector for March 16/17)
%Xlinfit (25 by 11 matrix, March 16/17)
%sigmasq standard deviation
%outputs sig_b_index, index of b values that are deemed significant
% sig_X_fit is the modified X_fit matrix containing only columns corresponding to significant b values 
    C = inv(X_fit'*X_fit);
    n = size(X_fit,1);
    p = length(b_val);
    DoF = n-p;
    % assume student-T test at 10% overall probability of incorrect
    % rejection
    StudentTMatrix = [6.314 2.92 2.353 2.132 2.015 1.943 1.895 1.86 1.833 1.812 1.796 1.782 1.771 1.761 1.753 1.746 1.740 1.734 1.729 1.725 1.721 1.717 1.714 1.711 1.708 1.706 1.703 1.701 1.699 1.697];
    t_comp = StudentTMatrix(DoF);
    for i = 1:length(b_val)
        t = b_val(i)/sqrt(sigmasq*C(i,i));
        if t >= t_comp
            sig_b_index_temp(i) = i;
        else
            sig_b_index_temp(i) = 0;
        end
    end
    
    sig_b_index = sig_b_index_temp(sig_b_index_temp ~= 0);
    for i = 1:length(sig_b_index)
        sig_X_fit(:,i) = X_fit(:,sig_b_index);
    end
end
    