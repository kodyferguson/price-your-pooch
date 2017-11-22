function [f] = Laplace_rule_mixture(X,Y,m,d,c,V)

% Compute a_j(x)
a_ = (abs(X - m)) / d;
a_x = exp(-1*a_);

%{
% Compute b_j(y)
s1 = V / 2;
b_y = laplacepdf(Y, c, s1);
%}

% Compute b_j(y)
sigma = V/sqrt(2*pi);
b_y = normpdf(Y,c,sigma);

f = a_x.*b_y;
end