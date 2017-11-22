functionString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/Gauss/fuzzyFGauss-10000.dat';
varianceString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/Gauss/fuzzyVGauss-10000.dat';


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
title('Function Approximation using Tri');

figure(7);
scatter3(Xv,Yv,Zv)
xlabel({'x'})
ylabel({'y'})
zlabel({'V[Z|X= x, Y= y]'})
title('Conditional Variance using Tri')
