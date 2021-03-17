function[R_squared, adj_R_squared, sigmasq] = polyfit_error(yval, yhat, X_fit)
    %inputs yval, actual calculated y values
    %yhat, y values evaluated from the polyfit
    %X_fit, Xfit matrix (25x11 for Mar 16 17)
    %outputs R_squared R^2 value
    %adj_R_squared adjusted R^2 value
    %sigmasq variance of the error, important for determining significant b
    %values
    n = length(yval);
    p = size(X_fit,2);
    error = yhat - yval;
    SSE = error'*error;
    sigmasq = SSE/(n-p);
    ymean = mean(mean(yval));
    SS_total = sum((yval - ymean).^2);
    SS_regress = SS_total-SSE;
    R_squared = SS_regress/SS_total;
    adj_R_squared = 1-(n-1)/(n-p)*(1-R_squared);
end
    