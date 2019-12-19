clear
clc

%% Test if the function to check if a point lies in the triangle formed
%% by three other points works or not
pointInTriangle = isPointInTriangle([0.5;0.5],[1.25;1.25],[1;1],[1;-1]);
%%

preDefinedPaths = importdata('paths.txt');
givenStartPoint = [2.7; 1.4];
pointInfo = {[0,0],[0,0],[0,0],false, [0,0], [0,0,0]};
for i=1:2:98    
    for j=1:2:98
        for k=1:2:98
            t1x = preDefinedPaths(i,1);
            t1y = preDefinedPaths(i+1,1);
            t1 = [t1x;t1y];
            t2x = preDefinedPaths(j,1);
            t2y = preDefinedPaths(j+1,1);
            t2 = [t2x;t2y];
            t3x = preDefinedPaths(k,1);
            t3y = preDefinedPaths(k+1,1);
            t3 = [t3x; t3y];
            [isInTriangle, solution] = isPointInTriangle(givenStartPoint, t1, t2, t3);
            if (isInTriangle)
                pointInfo{1} = t1;
                pointInfo{2} = t2;
                pointInfo{3} = t3;
                indices = [i,j,k];
                pointInfo{6} = indices;
                isTriangleOneSided = false; 
                if (t1(2) > t1(1) && t2(2) > t2(1) && t3(2) > t3(1))
                    isTriangleOneSided = true;
                    pointInfo{4} = true;
                    pointInfo{5} = [solution(1), solution(2)];
                elseif ((t1(2) < t1(1) && t2(2) < t2(1) && t3(2) < t3(1)))
                    isTriangleOneSided = true;
                    pointInfo{4} = true;
                    pointInfo{5} = [solution(1), solution(2)];
                end
                break;
            end
        end
        if (cell2mat(pointInfo(4)) == true)
            break
        end
    end
    if (cell2mat(pointInfo(4)) == true)
        break;
    end
end

tracedPath = [];
prePath1 = [];
prePath2 = [];
prePath3 = [];
for i= 1:1:50
        indexPoint1 = pointInfo{6}(1);
        indexPoint2 = pointInfo{6}(2);
        indexPoint3 = pointInfo{6}(3);
        predefinedPoint1X = preDefinedPaths(indexPoint1,i);
        predefinedPoint1Y = preDefinedPaths(indexPoint1+1,i);
        predefinedPoint1 = [predefinedPoint1X;predefinedPoint1Y];
        prePath1 = [prePath1, predefinedPoint1];
        %disp ("=============================")
        predefinedPoint2X = preDefinedPaths(indexPoint2,i);
        predefinedPoint2Y = preDefinedPaths(indexPoint2+1,i);
        predefinedPoint2 = [predefinedPoint2X;predefinedPoint2Y];
        prePath2 = [prePath2 predefinedPoint2];
        %disp ("=============================")
        predefinedPoint3X = preDefinedPaths(indexPoint3,i);
        predefinedPoint3Y = preDefinedPaths(indexPoint3+1,i);
        predefinedPoint3 = [predefinedPoint3X;predefinedPoint3Y];
        prePath3 = [prePath3, predefinedPoint3];
        %disp ("=============================")
        pointPath = (1 - pointInfo{5}(1) - pointInfo{5}(2))*predefinedPoint1 + ...
            pointInfo{5}(1)*predefinedPoint2 + pointInfo{5}(2)*predefinedPoint3;
        %disp ("=============================")
        tracedPath = [tracedPath, pointPath];
end
 h = circle(5,5,1.5);
 plot(tracedPath(1,:), tracedPath(2,:), 'b')
 plot(prePath1(1,:), prePath1(2,:), 'g')
 plot(prePath2(1,:), prePath2(2,:), 'g')
 plot(prePath3(1,:), prePath3(2,:), 'g')

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, 'r');
xlim([0, 12])
ylim([0, 12])
end

function[boolAns, solution] = isPointInTriangle(p, t1, t2, t3)
pivotPoint = t1;
side1 = t2 - pivotPoint;
side2 = t3 - pivotPoint;
AMat = [side1, side2];
bVec = p - pivotPoint;
solution = AMat\bVec;
validPoints = find(solution >=0 & solution <=1);
if (numel(validPoints) == numel(solution) && solution(1) + solution(2) <= 1)
    boolAns = true;
else
    boolAns = false;
end
end

