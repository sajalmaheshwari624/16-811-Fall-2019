clear
clc

Y = load('problem2.txt');
Y = Y';
Ynew = diff(Y);
plot (Y)
hold on
[~, index] = max(Ynew)

YPart1 = Y(1:index);
col1 = ones(size(YPart1));
xi = 0:0.1:(index-1)/10;
xi = xi';
xi2 = xi.^2;
xi3 = xi.^3;
A = [col1, xi, xi2, xi3];
coeff1 = A\YPart1
resA = A*coeff1;

YPart1 = Y(index+1:end);
col1 = ones(size(YPart1));
xi = index/10:0.1:10;
xi = xi';
xi2 = xi.^2;
xi3 = xi.^3;
A = [col1, xi, xi2, xi3];
coeff2 = A\YPart1
resB = A*coeff2;

res = [resA; resB];
plot(res, 'r*')
hold off