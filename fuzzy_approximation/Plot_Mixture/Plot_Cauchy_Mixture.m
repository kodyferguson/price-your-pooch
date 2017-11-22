clear;
addpath('compute_mixture');
X = 0:0.01:7;
Y = -1:0.01:1;
[xin, yin] = meshgrid(X,Y); 
% Plot for Cauchy
%par = importdata('../ASAM-1D/Cauchy/Parameters.par');
par = importdata('/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/Tanh/Parameters.par');v
data = par.data;

[N, D] = size(data);
fx = 0.0;

for i = 1:1:N
    fx = fx +  Cauchy_rule_mixture(xin, yin, data(i, 1),   data(i,2),  data(i,3),   data(i,4));
end

fx = (1/N)* fx;

figure(2);
surf(xin,yin,fx);

xlabel({'x'})
ylabel({'y'})
zlabel({'f(y|X=x)'})
title(['MIXTURE FOR FUZZY SYSTEM (',num2str(N),' Cauchy Rules)']);