clear;
addpath('compute_mixture');
X = 1:1:20;
Y = 0:100:3900;
[xin, yin] = meshgrid(X,Y);
% Plot for Gausssian mixtures
par = importdata('/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/Gauss/Parameters.par');
data = par.data;

[N, D] = size(data);
fx = 0.0;

%Plots for no champion heritage
f_noH = zeros(20, 40);
for i = 1:20
    for j = 1:40
        f_noH(i,j) = Gauss2d_rule_mixture()

for i = 1:1:N
    fx = fx +  Gauss2d_rule_mixture(xin, yin, data(i, 1),   data(i,2),  data(i,3),   data(i,4));
end

fx = (1/N)* fx;

figure(1);
surf(xin,yin,fx);

xlabel({'x'})
ylabel({'y'})
zlabel({'f(y|X=x)'})
title(['MIXTURE FOR FUZZY SYSTEM (',num2str(N),' Gaussian Rules)']);