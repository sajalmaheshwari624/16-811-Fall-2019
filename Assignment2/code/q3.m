clear
clc

tolerance = 4;
startBracket = 7;
interval = 0.1;
endBracket = [7 - pi, 7 + pi];
precision = 0.00001;
startingPoint = startBracket;
f = @(x)tan(x)-x;
df = @(x)sec(x)*sec(x) - 1;

% 1st root ----- Greater than 7 ------ %
for i=startBracket:interval:endBracket(2)
    xValue = i;
    yValue = tan(xValue) - xValue;
    if (abs(yValue) < tolerance)
        minVal = yValue;
        startingPoint = xValue;
    end
end

rootVal = tan(startingPoint) - startingPoint;
rootPoint = startingPoint;

while (abs(rootVal) > precision)
    rootPoint;
    rootPoint = rootPoint - (f(rootPoint)) / df(rootPoint);
    rootVal = tan(rootPoint) - rootPoint;
end
disp ("First root : ")
disp(rootPoint)

% 2nd root ---- Less than 7 ------ %
for i=endBracket(1):interval:startBracket
    xValue = i;
    yValue = tan(xValue) - xValue;
    if (abs(yValue) < tolerance)
        minVal = yValue;
        startingPoint = xValue;
    end
end

rootVal = tan(startingPoint) - startingPoint;
rootPoint = startingPoint;

while (abs(rootVal) > precision)
    rootPoint;
    rootPoint = rootPoint - (f(rootPoint)) / df(rootPoint);
    rootVal = tan(rootPoint) - rootPoint;
end

disp ("Second root :")
disp (rootPoint)

