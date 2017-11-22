functionString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/InputFxn.dat';
fx = importdata(funCat);
variance = importdata(varCat);
Xf = fx.data(:,1);
Yf = fx.data(:,2);
Xv = variance.data(:,1);
Yv = variance.data(:,2);


figure(6);
plot(Xf,Yf)
xlabel({'x'})
ylabel({'y'})
title('Test Function');