function [f] = Tanh_rule_mixture(X,Y,m,d,c,V)

% Compute a_j(x)
a_ = ((X - m)/ d).^2;
a_x = 1 + tanh(-a_);

% Compute b_j(y)
sigma = V/sqrt(2*pi);
b_y = normpdf(Y,c,sigma);


f = a_x.*b_y;
end