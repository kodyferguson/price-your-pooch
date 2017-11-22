function [f] = Cauchy_rule_mixture(X,Y,m,d,c,V)

% Compute a_j(x)
a_ = ((X - m)/ d).^2;
a_ = 1 + a_;
a_x = 1./(a_);

% Compute b_j(y)
%{
s1 = V / pi;
b_y = cauchypdf(Y, c, s1);
%}

sigma = V/sqrt(2*pi);
b_y = normpdf(Y,c,sigma);

f = a_x.*b_y;
end