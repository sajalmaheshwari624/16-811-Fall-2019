clear
clc

A1 = [10.0, 6.0, 4.0; 5.0, 3.0, 2.0; 1.0, 1.0, 0.0]
b1 = [1.0, 3.0, -1.0]
tolerance = 0.00000000001;
ansA1 = findSolution(A1, b1, tolerance)
[errorVec, errorVal] = findError(A1, b1, ansA1)
function [vecAns] = findSolution(inMatrix, biasVec, tolerance)
    [U, S, V] = svd(inMatrix);
    nonZeroS = find(S >= tolerance);
    for i=1:1:size(nonZeroS)
        S(nonZeroS(i)) = 1 / S(nonZeroS(i)); 
    end
    vecAns = V * (S) * (U') * biasVec';
    [rows, cols] = size(inMatrix);
    if (rows == cols && det(inMatrix) ~= 0)
        disp ("Unique exact solution!!")
    else
        rankInMatrix = rank(inMatrix);
        colSpaceInMatrix = U(:, 1:rankInMatrix);
        biasReconstruct = zeros(size(biasVec'));
        for i=1:1:rankInMatrix
            coefficients = biasVec .* colSpaceInMatrix(:,i);
            biasReconstruct = biasReconstruct + coefficients * colSpaceInMatrix(:,i);
        end
        count = 0;
        for i=1:1:size(biasVec')
            if (abs(biasReconstruct(i) - biasVec(i)) > tolerance)
                count = count + 1;
            end
        end
        if (count == 0)
            disp ("Multiple Exact solutions!")
        else
            disp ("SVD solution!")
        end
    end
end

function [errorVec, errorMag] = findError(inMatrix, biasVec, solutionVec)
    solution = inMatrix*solutionVec;
    errorVec = biasVec' - solution;
    errorMag = norm(errorVec);
end