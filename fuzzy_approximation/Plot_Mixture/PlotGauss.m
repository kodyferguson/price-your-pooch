epoch = 2000;
rules = 10;
iter = epoch * 19;
functionString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/Gauss/fuzzyFGauss-';
varianceString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/Gauss/fuzzyVGauss-';
funCat = strcat(functionString,num2str(iter),'.dat');
varCat = strcat(varianceString,num2str(iter),'.dat');


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
title('Function Approximation using Gauss');
%title({'Function with '; ['epoch = ',num2str(epoch),' and rules = ',num2str(rules)]}, 'FontWeight','Normal','FontSize',8);

figure(7);
plot(Xv,Yv)
xlabel({'x'})
ylabel({'V[Y|X = x]'})
title('Conditional Variance using Gauss')
%title({'Cond. Var. with epoch=',num2str(epoch),', rules=',num2str(rules)}, 'FontWeight','Normal','FontSize',8)