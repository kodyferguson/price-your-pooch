function f = Gauss2d_approximation(Parameters, xin,yin)

NUMPAT = size(Parameters,1); %number of rules 
xmdgs = zeros(NUMPAT,1);
ymdgs = zeros(NUMPAT,1);
a = zeros(NUMPAT,1);
meanX = Parameters(:, 1);
meanY = Parameters(:, 2);
dispX = Parameters(:,3);
dispY = Parameters(:,4);
centroid = Parameters(:,5); 
volume = Parameters(:,6);

dengs = 0.0; num = 0.0;
for n = 1:NUMPAT        %foreach fuzzy rule...
    xmdgs(n,1) = (xin-meanX(n,1))/dispX(n,1); %calc intermediate centered gaussian xvar
    ymdgs(n,1) = (yin-meanY(n,1))/dispY(n,1); %calc intermediate centered gaussian yvar
    a(n,1) = exp(-(xmdgs(n,1)*xmdgs(n,1)) - (ymdgs(n,1)*ymdgs(n,1))); %calc Gaussian fit value
    av = a(n,1)*volume(n,1); %calc fit-scaled volume of then-part
    dengs = dengs+av;   %calc denominator of SAM
    num = num+av*centroid(n,1);	%calc numerator of SAM
end

if dengs ~= 0.0
    f = num/dengs;
else 
    f = 0.0;
end

end


