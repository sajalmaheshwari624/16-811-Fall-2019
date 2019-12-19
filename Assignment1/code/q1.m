clear 
clc

N = randi(10);
A = rand(N);
[P,L,D,U] = LDUDecompose(A);
originalA = P*A;
reconA = L*D*U;
errorA = originalA - reconA;
errorFinal = sum(errorA(:))
function [P,L,D,U] = LDUDecompose(inMatrix)
    [rows, cols] = size(inMatrix);
    P = eye(rows);
    
    if (rows~= cols)
        disp ("Non-square matrix! Can not be decomposed using this code.")
        L = [];
        D = [];
        U = [];
        return
    elseif(det(inMatrix) == 0)
        disp ("Singular matrix! Can not be decomposed using this code.")
        L = [];
        D = [];
        U = [];
        return
    end
    
    diagElements = ones(rows, 1);
    L = diag(diagElements);
    for i=1:1:cols - 1
        for j = i:1:rows
            if (i == j) 
                if (inMatrix(j,i) == 0)
                    colI = inMatrix(i+1:end,j);
                    [~, ind] = max(abs(colI));
                    currentRow = inMatrix(j,:);
                    maxRow = inMatrix(ind+j, :);
                    inMatrix(ind+j, :) = currentRow;
                    inMatrix(j,:) = maxRow;
                    PmaxRow = P(ind+j,:);
                    PcurrentRow = P(j,:);
                    P(j,:) = PmaxRow;
                    P(ind+j,:) = PcurrentRow;
                end
            end
            colI = inMatrix(i+1:end,j);
            ratio = colI / inMatrix(j,i);
            ratioMat = zeros(1,cols - i);
            for k = 1:size(ratio)
                if (k == 1)
                    ratioMat = ratio(k)*inMatrix(j,i:end);
                else
                    ratioMat = [ratioMat; ratio(k)*inMatrix(j,i:end)];
                end
            end
            inMatrix(j+1:end,i:end) = inMatrix(j+1:end,i:end) - ratioMat;
            L(j+1:end, i) = ratio;
            break
        end
    end
    U = inMatrix;
    diagElements = diag(U);
    zeroElements = find(diagElements == 0);
    diagElements(zeroElements) = 1;
    D = diag(diagElements);
    diagMat = repmat(diagElements, 1, cols);
    U = U ./(diagMat);
end