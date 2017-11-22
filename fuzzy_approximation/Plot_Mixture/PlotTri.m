epoch = 2000;
rules = 10;
iter = epoch * 19;
functionString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/Tri/fuzzyFTri-';
varianceString = '/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-1D/Tri/fuzzyVTri-';
funCat = strcat(functionString,num2str(19000),'.dat');
varCat = strcat(varianceString,num2str(19000),'.dat');

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
title('Function Approximation using Tri');
%title({'Function with '; ['epoch = ',num2str(epoch),' and rules = ',num2str(rules)]}, 'FontWeight','Normal','FontSize',8);

figure(7);
plot(Xv,Yv)
xlabel({'x'})
ylabel({'V[Y|X = x]'})
title('Conditional Variance using Tri')
%title({'Cond. Var. with epoch=',num2str(epoch),', rules=',num2str(rules)}, 'FontWeight','Normal','FontSize',8)