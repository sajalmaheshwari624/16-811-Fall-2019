clear
clc
close all

func = @(x) sqrt(2*x - 2);
dfunc = @(y) (1/y); 
stepSize = -0.05;
startPoint = 2;
endPoint = 1;
point1 = 2.05;
point2 = 2.10;
point3 = 2.15;

%% Code for Part B
[inputArr, estimateOutEuler, realOutEuler, errorsEuler] = Euler(startPoint, endPoint, stepSize, func, dfunc);
avgErrorEuler = mean(errorsEuler)
TableEuler = table(inputArr,estimateOutEuler,realOutEuler,errorsEuler);
TableEuler.Properties.VariableNames = {'Input','EstimatedOutput','ActualOutput','Error'};
figure,plot(inputArr, estimateOutEuler, 'r')
hold on
plot(inputArr, realOutEuler, 'g')
hold off
figure, plot(inputArr, errorsEuler)
hold off

%% Code for Part C
[inputArr, estimateOutRK, realOutRK, errorsRK] = RungeKutta(startPoint, endPoint, stepSize, func, dfunc);
avgErrorRK = mean(errorsRK)
TableRK = table(inputArr,estimateOutRK,realOutRK,errorsRK);
TableRK.Properties.VariableNames = {'Input','EstimatedOutput','ActualOutput','Error'};
figure,plot(inputArr, estimateOutRK, 'r')
hold on
plot(inputArr, realOutRK, 'g')
hold off
figure, plot(inputArr, errorsRK)
hold off

%% Code for Part C
[inputArr, estimateOutAB, realOutAB, errorsAB] = AdamBatch(startPoint, endPoint, stepSize, func, dfunc);
avgErrorAB = mean(errorsAB)
TableAB = table(inputArr,estimateOutAB,realOutAB,errorsAB);
TableAB.Properties.VariableNames = {'Input','EstimatedOutput','ActualOutput','Error'};
figure,plot(inputArr, estimateOutAB, 'r')
hold on
plot(inputArr, realOutAB, 'g')
hold off
figure, plot(inputArr, errorsAB)
hold off


function[inputArr, estimateOut, realOut, errors] = Euler(startPoint, endPoint, stepSize, func, dfunc)
    yVal = func(startPoint);
    estimateOut = [];
    realOut = [];
    errors = [];
    inputArr = [];
    for i= startPoint: stepSize : endPoint
        realY = func(i);
        inputArr = [inputArr; i];
        if (i == startPoint)
            estimateY = func(i);
        else
            estimateY = yVal + stepSize * dfunc(yVal);
        end
        yVal = estimateY;
        estimateOut = [estimateOut; yVal];
        realOut = [realOut; realY];
        errors = [errors; abs(yVal -realY)];
    end
end

function [inputArr, estimateOut, realOut, errors] = RungeKutta(startPoint, endPoint, stepSize, func, dfunc)
    yVal = func(startPoint);
    estimateOut = [];
    realOut = [];
    inputArr = [];
    for i = startPoint:stepSize:endPoint
        realY = func(i);
        inputArr = [inputArr; i];
        if (i == startPoint)
            estimateOut = yVal;
        else
            k1 = stepSize*(dfunc(estimateOut(numel(estimateOut))));
            k2 = stepSize*(dfunc(estimateOut(numel(estimateOut)) + k1/2));
            k3 = stepSize*(dfunc(estimateOut(numel(estimateOut)) + k2/2));
            k4 = stepSize*(dfunc(estimateOut(numel(estimateOut)) + k3));
            yNext = estimateOut(numel(estimateOut)) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
            estimateOut = [estimateOut; yNext];
        end
        yReal = func(i);
        realOut = [realOut; yReal];
    end
    errors = abs(realOut - estimateOut);
end

function[inputArr, estimateOut, realOut, errors] = AdamBatch(startPoint, endPoint, stepSize, func, dfunc)
    yVal = func(startPoint);
    estimateOut = [];
    realOut = [];
    inputArr = [];
    
    fn = dfunc( 1.4142135623731);
    fnMinus1 = dfunc(1.44913767461894);
    fnMinus2 = dfunc(1.48323969741913);
    fnMinus3 = dfunc(1.51657508881031);
    
    for i=startPoint:stepSize:endPoint
        inputArr = [inputArr; i];
        if (i == startPoint)
            estimateOut = yVal;
            yReal = func(i);
            realOut = [realOut; yReal];
        else
            yNext = estimateOut(numel(estimateOut)) + (stepSize/24)*(55*dfunc(estimateOut(numel(estimateOut))) ...
                - 59*fnMinus1 + 37*fnMinus2 - 9*fnMinus3);
            fnMinus3 = fnMinus2;
            fnMinus2 = fnMinus1;
            fnMinus1 =  dfunc(estimateOut(end));
            estimateOut = [estimateOut; yNext];
            yReal = func(i);
            realOut = [realOut; yReal];
        end
    end
    errors = abs(estimateOut - realOut);
end