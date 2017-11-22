function [f] = Tri_rule_mixture(X,Y,m,d,c,V)

w = d /2;

aj_x = zeros(size(X));
% Compute a_j(x)
for i = 1:1:size(X,1)
    for j = 1:1:size(X,2)
        
        if (((m - w) <= X(i,j)) && (X(i,j) <= m))
            aj_x(i, j) = 1 - (m - X(i,j))/w;
        elseif ((m <= X(i,j)) && (X(i,j) <= (m + w)))
            aj_x(i, j) = 1 - (X(i,j) - m)/w;
        else
            aj_x(i,j) = 0;
        end
    end
end

% Compute b_j(y)
%{
w1 = V;
bj_y = zeros(size(Y));
% Compute a_j(x)
for i = 1:1:size(Y,1)
    for j = 1:1:size(Y,2)        
        if (((c - w1) <= Y(i,j)) && (Y(i,j) <= c))
            bj_y(i, j) = 1 - (c - Y(i,j))/w1;
        elseif ((c <= Y(i,j)) && (Y(i,j) <= (c + w1)))
            bj_y(i, j) = 1 - (Y(i,j) - c)/w1;
        else
            bj_y(i,j) = 0;
        end
    end
end
%}

sigma = V/sqrt(2*pi);
bj_y = normpdf(Y,c,sigma);
f = aj_x.*bj_y;
end

