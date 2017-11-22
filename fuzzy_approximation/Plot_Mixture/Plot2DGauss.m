functionString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/Gauss/fuzzyFGauss-2500.dat';
varianceString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/Gauss/fuzzyVGauss-2500.dat';


fx = importdata(functionString);
variance = importdata(varianceString);
Xf = fx.data(:,1);
Yf = fx.data(:,2);
Xv = variance.data(:,1);
Yv = variance.data(:,2);
Zf = fx.data(:,3);
Zv = variance.data(:,3);

figure(6);
scatter3(Xf,Yf,Zf)
xlabel({'x'})
ylabel({'y'})
title('Function Approximation using Gauss');

figure(7);
scatter3(Xv,Yv,Zv)
xlabel({'x'})
ylabel({'y'})
zlabel({'V[Z|X= x, Y= y]'})
title('Conditional Variance using Gauss')
