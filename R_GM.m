function [R2_GM,R2_adj_GM,sig_GM] = R_GM(D1,D2,T1,T2,GM)
%Calculate Regression for GM

test = 2.074; %alpha = 5%, n-p = 20

X_GM = [ones(size(D1,1),1) D1(:,1) D2(:,1) T1(:,1) T2(:,1) D1(:,1).^2 D2(:,1).^2 D1(:,1).*D2(:,1)];
b_GM = ((transpose(X_GM)*X_GM)^-1)*(transpose(X_GM))*GM;

[numRows , numCols] = size(b_GM);

p = numRows;
n = length(GM);

yhat_GM = X_GM*b_GM;

e_GM = yhat_GM-GM;

SSE_GM = transpose(e_GM)*e_GM;
ymean_GM = mean(GM);
sigma_sq = SSE_GM/(n-p);

SST_GM = sum((GM-ymean_GM).^2);
SSR_GM = SST_GM - SSE_GM;

R2_GM = SSR_GM/SST_GM;

R2_adj_GM = 1-((n-1)/(n-p))*(1-R2_GM);

C = (transpose(X_GM)*X_GM)^-1;

t00 = b_GM(1)/sqrt(sigma_sq*C(1,1));
t01 = b_GM(2)/sqrt(sigma_sq*C(1,2));
t02 = b_GM(3)/sqrt(sigma_sq*C(1,3));
t03 = b_GM(4)/sqrt(sigma_sq*C(1,4));
t04 = b_GM(5)/sqrt(sigma_sq*C(1,5));
t05 = b_GM(6)/sqrt(sigma_sq*C(1,6));
t06 = b_GM(7)/sqrt(sigma_sq*C(1,7));
t07 = b_GM(8)/sqrt(sigma_sq*C(1,8));

t = [t00; t01; t02; t03; t04; t05; t06; t07];
t_test = [ones(size(t(:,1)))]*test;
sig_GM = [zeros(size(t(:,1)))]

i=1;
for i=1:size(t)
    if t_test(i,1) > abs(t(i,1))
        sig_GM(i,1) = 0;
    else
       sig_GM(i,1) = 1;
    end
    i = i+1;
end

% sig_GM = t_test-abs(t);

end

