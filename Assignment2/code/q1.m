clear
clc

% %%% ---------------------------- Part b specific code start---------------%%%%
 indVar = [0; 1/8; 1/4; 1/2; 3/4; 1];
 depVar = exp(-indVar);
 x = 1/3;
 estimatedOut = NewtonInterp(x, indVar, depVar);
 disp ([x,estimatedOut])
 realOut = exp(-x);
 error = abs(realOut - estimatedOut)
% %%% ---------------------------- Part b specific code end---------------%%%%

%%% ---------------------------- Part c specific code start---------------%%%%
% n = 40
% indVar = [];
% for i = 0:1:n
%     indVar = [indVar; (i * 2 / n) - 1];
% end
% squaredVal = indVar .* indVar;
% depVar = 1 ./ (1 + 16 .* squaredVal);
% x = 0.05;
% estimatedOut = NewtonInterp(x, indVar, depVar);
% disp ([x, estimatedOut])
% realOut = 1 / (1 + 16 * x * x)
% error = abs (estimatedOut - realOut);
%%%% ---------------------------- Part c specific code end---------------%%%%

%%%% -------------------------Part d specific code start-------------%%%%

 N = [ 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 40];
 xArray = linspace(-1, 1, 100);
 NNumber = numel(N);
 xNum = numel(xArray);
 outputs = [];
 for i=1:1:NNumber
     n = N(i);
     indVar = [];
     for j = 0:1:n
         indVar = [indVar; (j * 2 / n) - 1];
     end
     squaredVal = indVar .* indVar;
     depVar = 1 ./ (1 + 16 .* squaredVal);
     errorMax = -999999999;
     valMax = -1.5;
     for k=1:1:xNum
         x = xArray(k);
         estimatedOut = NewtonInterp(x, indVar, depVar)
         realOut = 1 / (1 + 16 * x * x);
         error = abs(estimatedOut - realOut);
         if (error > errorMax)
             errorMax = error;
             valMax = x;
         end
     end
     disp ("Value of n")
     disp (n)
     output = [errorMax, valMax];
     disp (output)
 end
disp (outputs)

function [output] = NewtonInterp(x, indVar, depVar)
    [numVal,~] = size(indVar);
    matZeros = diag(depVar);
    for i=2:1:numVal
        rowNum = 0;
        for j = i:1:numVal
            rowNum = rowNum + 1;
            colNum = j;
            matZeros(rowNum, colNum) = (matZeros(rowNum + 1, colNum) - matZeros(rowNum, colNum-1)) / ...
                (indVar(colNum) - indVar(rowNum));
        end
    end
    coeff = matZeros(1,:);
    prod = 1;
    coeffProd = coeff(1);
    for i = 2:1:numVal
        prod = prod * (x - indVar(i - 1));
        coeffProd = coeffProd + coeff(i) * prod;
        
    end
    output = coeffProd; 
end


