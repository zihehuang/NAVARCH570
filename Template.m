clc, clear all, close all 
%% Sample points D1_1= 20-30 , D2-1=8-10 , T1=35-40 , T2= 15-20
% Dimensional inputs D1_1= 20-30 , D2-1=8-10 , T1=35-40 , T2= 15-20
D1_1=[20 30	20	30	20	30	20	30	20	30	20	30	20	30	20	30	25	15	35	25	25	25	25	25	25]';
D2_1=[8	8 10	10	8	8	10	10	8	8	10	10	8	8	10	10	9	9	9	7	11	9	9	9	9]';
T1_1=[35 35	35	35	40	40	40	40	35	35	35	35	40	40	40	40	37.5	37.5	37.5	37.5	37.5	32.5	42.5	37.5	37.5]';
T2_1=[15 15	15	15	15	15	15	15	20	20	20	20	20	20	20	20	17.5	17.5	17.5	17.5	17.5	17.5	17.5	12.5	22.5]';
% Dimensional inputs D1_1= 15-20 , D2-1=6-8 , T1=30-35 , T2= 20-25
D1_2=[15 20	15	20	15	20	15	20	15	20	15	20	15	20	15	20	17.5	12.5	22.5	17.5	17.5	17.5	17.5	17.5	17.5]';
D2_2=[6	6 8	8	6	6	8	8	6	6	8	8	6	6	8	8	7	7	7	5	9	7	7	7	7]';
T1_2=[30 30	30	30	35	35	35	35	30	30	30	30	35	35	35	35	32.5 32.5 32.5	32.5 32.5 27.5	37.5 32.5 32.5]';
T2_2=[20 20	20	20	20	20	20	20	25	25	25	25	25	25	25	25	22.5	22.5	22.5	22.5	22.5	22.5	22.5	17.5	27.5]';
% Dimensional inputs D1_1= 25-35 , D2-1=10-20 , T1=20-30 , T2= 8-18
D1_3=[25	35	25	35	25	35	25	35	25	35	25	35	25	35	25	35	30	20	40	30	30	30	30	30	30]';
D2_3=[10	10	20	20	10	10	20	20	10	10	20	20	10	10	20	20	15	15	15	5	25	15	15	15	15]';
T1_3=[20	20	20	20	30	30	30	30	20	20	20	20	30	30	30	30	25	25	25	25	25	15	35	25	25]';
T2_3=[8	8	8	8	8	8	8	8	18	18	18	18	18	18	18	18	13	13	13	13	13	13	13	3	23]';
% Dimensional inputs D1_1= 10-20 , D2-1=5-9 , T1=10-20 , T2= 5-10
D1_4=[10	20	10	20	10	20	10	20	10	20	10	20	10	20	10	20	15	5	25	15	15	15	15	15	15]';
D2_4=[5	5	9	9	5	5	9	9	5	5	9	9	5	5	9	9	7	7	7	3	11	7	7	7	7]';
T1_4=[10	10	10	10	20	20	20	20	10	10	10	10	20	20	20	20	15	15	15	15	15	5	25	15	15]';
T2_4=[5	5	5	5	5	5	5	5	10	10	10	10	10	10	10	10	7.5	7.5	7.5	7.5	7.5	7.5	7.5	2.5	12.5]';
%% Output (GM)

%% Yval GM 
% Yval_GM=GM;
% Yval_WS=WS;
% Yval_NH=NH;
% Yval_Ps=Ps;
%% Linear fit and Poly fit
X0=ones(25,1);
X1=[-1	1	-1	1	-1	1	-1	1	-1	1	-1	1	-1	1	-1	1	0	-2	2	0	0	0	0	0	0]'; %D1
X2=[-1	-1	1	1	-1	-1	1	1	-1	-1	1	1	-1	-1	1	1	0	0	0	-2	2	0	0	0	0]'; %D2
X3=[-1	-1	-1	-1	1	1	1	1	-1	-1	-1	-1	1	1	1	1	0	0	0	0	0	-2	2	0	0]'; %T1
X4=[-1	-1	-1	-1	-1	-1	-1	-1	1	1	1	1	1	1	1	1	0	0	0	0	0	0	0	-2	2]'; %T2
X5=X1.*X2; %D1D2
X6=X3.*X4; %T1T2
X7=X1.^2; %D1^2
X8=X2.^2; %D2^2
X9=X3.^2; %T1^2
X10=X4.^2; %D1^2
Xlinfit=[X0 X1 X2 X3 X4];
Xlinfit_T=[X0 X1 X2 X3 X4]';
Xpolfit=[X0 X1 X2 X3 X4 X5 X6 X7 X8 X9 X10];
Xpolfit_T=[X0 X1 X2 X3 X4 X5 X6 X7 X8 X9 X10]';
%% Lin fit 
b_lin=(Xlinfit_T*Xlinfit)^-1*Xlinfit_T*Yval_GM; % b (parameters) Linear
b_lin(1,1)=b0;
b_lin(2,1)=b1;
b_lin(3,1)=b2;
b_lin(4,1)=b3;
b_lin(5,1)=b4;
Yhat_lin=b0*X0+b1*X1+b2*X2+b3*X3+b4*X4;
e_lin=Yhat_lin-Yval; %error (Linear)
e_lin_T=(e_lin)'; %error Transpose (Linear)
SSE_lin=e_lin_T*e_lin; %Sum of Square errors (Linear)
Yval_sum=sum(Yval); %Sum of Yval columns 
SST_lin=(Yval)'*Yval-Yval_sum/25; %Total Squared Varience from mean (Linear)
SSR_lin=SST_lin-SSE_lin; %Sum of Squared Regression (Linear)
R2_lin=SSR_lin/SST_lin*100; % R2 (Linear)
R2_adj_lin=(1-(25-1)/(25-5)*(1-SSR_lin/SST_lin))*100; % Adjusted R2 (Linear)

%pol fit 
b_pol=(Xpolfit_T*Xpolfit)^-1*Xpolfit_T*Yval_GM; % b (parameters) polynomial 
b_pol(1,1)=b_lin(1,1);
b_pol(2,1)=b_lin(2,1);
b_pol(3,1)=b_lin(3,1);
b_pol(4,1)=b_lin(4,1);
b_pol(5,1)=b_lin(5,1);
b_pol(6,1)=b5;
b_pol(7,1)=b6;
b_pol(8,1)=b7;
b_pol(9,1)=b8;
b_pol(10,1)=b9;
b_pol(11,1)=b10;
Yhat_pol=b0*X0+b1*X1+b2*X2+b3*X3+b4*X4+b5*X5+b6*X6+b7*X7+b8*X8+b9*X9+b10*X10;
e_pol=Yhat_pol-Yval; %error (Linear)
e_pol_T=(e_pol)'; %error Transpose (Linear)
SSE_pol=e_pol_T*e_pol; %Sum of Square errors (Linear)
Yval_sum=sum(Yval); %Sum of Yval columns 
SST_pol=(Yval)'*Yval-Yval_sum/25; %Total Squared Varience from mean (Linear)
SSR_pol=SST_pol-SSE_pol; %Sum of Squared Regression (Linear)
R2_pol=SSR_pol/SST_pol*100; % R2 (Linear)
R2_adj_pol=(1-(25-1)/(25-11)*(1-SSR_pol/SST_pol))*100; % Adjusted R2 (Linear)