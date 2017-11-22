function [f] = Sinc_rule_mixture(X,Y,m,d,c,V)

% Compute a_j(x)
aj_x = zeros(size(X));

for i = 1:1:size(X,1)
    for j = 1:1:size(X,2)
        
        if ( (X(i,j) - m) == 0)
            aj_x(i,j) = 1;
        else
            a_ = (X(i, j)- m) / d;
            aj_x(i, j) = (sin(a_) / a_);
        end
    end
end

% Compute b_j(y)
sigma = V/sqrt(2*pi);
b_y = normpdf(Y,c,sigma);

f = aj_x.*b_y;
end