clear
clc

clear_table_data = load('clear_table.txt');
%%% Code for part A
x = clear_table_data(:,1);
y = clear_table_data(:,2);
z = clear_table_data(:,3);
A = [x, y, ones(size(z))];
coeff_clean = A\ z
[x1, y1] = meshgrid(-1.5:0.01:1.5);
z1 = coeff_clean(1)*x1 + coeff_clean(2)*y1 + coeff_clean(3);
surf (x1,y1,z1)
hold on
plot3(clear_table_data(:,1), clear_table_data(:,2), clear_table_data(:,3), 'r')
hold off
c1 = coeff_clean(1);
c2 = coeff_clean(2);
c3 = -1;
c4 = coeff_clean(3);
dist = 0;
for i=1:1:size(A,1)
    distPoint = abs(c1*x(i) + c2*y(i) + c3*z(i) + c4);
    norm = c1*c1 + c2*c2 + c3*c3;
    distNorm = distPoint / sqrt(norm);
    dist = dist + distNorm;
end
dist = dist/size(A,1)

%%Code for part B
clutter_table_data = load('cluttered_table.txt');
x = clutter_table_data(:,1);
y = clutter_table_data(:,2);
z = clutter_table_data(:,3);
A = [x, y, ones(size(z))];
coeff_noisy = A\ z
[x1, y1] = meshgrid(-1.5:0.01:1.5);
z1 = coeff_noisy(1)*x1 + coeff_noisy(2)*y1 + coeff_noisy(3);
surf (x1,y1,z1)
hold on
plot3(clutter_table_data(:,1), clutter_table_data(:,2), clutter_table_data(:,3), 'r')
hold off

%%% Code for part C

clutter_table_data = load('cluttered_table.txt');
finalCoeff = ransac(clutter_table_data,1000, 0.0029, 0)
[x1,y1] = meshgrid(-1.5:0.01:1.5);
z1 = finalCoeff(1)*x1 + finalCoeff(2)*y1 + finalCoeff(3);
surf (x1,y1,z1)
hold on
plot3(clutter_table_data(:,1), clutter_table_data(:,2), clutter_table_data(:,3), 'r')
hold off

%% Code for part D
clean_hallway_data = load('clean_hallway.txt');
xMin = min(clean_hallway_data(:,1));
xMax = max(clean_hallway_data(:,1));
yMin = min(clean_hallway_data(:,2));
yMax = max(clean_hallway_data(:,1));
plot3(clean_hallway_data(:,1), clean_hallway_data(:,2), clean_hallway_data(:,3))
hold on

coeffPlane1 = ransac(clean_hallway_data, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane1,0.01, clean_hallway_data);
clean_hallway_data(planeIndices,:) = [];
%size(clean_hallway_data)
%plot3(planeIndices(:,1), planeIndices(:,2), planeIndices(:,3))


coeffPlane2 = ransac(clean_hallway_data, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane2,0.01, clean_hallway_data);
clean_hallway_data(planeIndices,:) = [];
%%size(clean_hallway_data)
%plot3(planeIndices(:,1), planeIndices(:,2), planeIndices(:,3))

coeffPlane3 = ransac(clean_hallway_data, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane3,0.01, clean_hallway_data);
clean_hallway_data(planeIndices,:) = [];
%%size(clean_hallway_data)
%%plot3(planeIndices(:,1), planeIndices(:,2), planeIndices(:,3))

coeffPlane4 = ransac(clean_hallway_data, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane4,0.01, clean_hallway_data);
clean_hallway_data(planeIndices,:) = [];
%%size(clean_hallway_data)
%plot3(planeIndices(:,1), planeIndices(:,2), planeIndices(:,3))

[x1,y1] = meshgrid(xMin:0.01:xMax, yMin:0.01:yMax);
z1 = coeffPlane1(1)*x1 + coeffPlane1(2)*y1 + coeffPlane1(3);
z2 = coeffPlane2(1)*x1 + coeffPlane2(2)*y1 + coeffPlane2(3);
z3 = coeffPlane3(1)*x1 + coeffPlane3(2)*y1 + coeffPlane3(3);
z4 = coeffPlane4(1)*x1 + coeffPlane4(2)*y1 + coeffPlane4(3);
surf (x1,y1,z1)
surf (x1,y1,z2)
surf (x1,y1,z3)
surf (x1,y1,z4)
hold off

function[pointIndices] = checkPointInPlane(coeffs, tol, dataPoints)
    c1 = coeffs(1);
    c2 = coeffs(2);
    c3 = -1;
    c4 = coeffs(3);
    dist = 0;
    pointIndices = [];
    x = dataPoints(:,1);
    y = dataPoints(:,2);
    z = dataPoints(:,3);
    for i=1:1:size(dataPoints,1)
        distPoint = abs(c1*x(i) + c2*y(i) + c3*z(i) + c4);
        norm = c1*c1 + c2*c2 + c3*c3;
        distNorm = distPoint / sqrt(norm);
        dist = distNorm;
        if (dist < tol)
            pointIndices = [pointIndices, i];
        end
    end
end

function[finalCoeff] = ransac(dataPoints, iter, tolerance, inliers)
    num_examples = size(dataPoints, 1);
    for i=1:1:iter
        randCombination = randperm(num_examples);
        ransacInputIndex = randCombination(1:3);
        x = dataPoints(ransacInputIndex,1);
        y = dataPoints(ransacInputIndex,2);
        z = dataPoints(ransacInputIndex,3);
        A = [x,y,ones(size(z))];
        coeff = A\z;
        xEval = dataPoints(randCombination(4:end),1);
        yEval = dataPoints(randCombination(4:end),2);
        zEval = dataPoints(randCombination(4:end),3);
        AEval = [xEval, yEval, ones(size(zEval))];
        c1 = coeff(1);
        c2 = coeff(2);
        c3 = -1;
        c4 = coeff(3);
        count = 0;
        for j=1:1:size(AEval,1)
            distPoint = abs(c1*xEval(j) + c2*yEval(j) + c3*zEval(j) + c4);
            norm = c1*c1 + c2*c2 + c3*c3;
            dist = distPoint / sqrt(norm);
            if (dist < tolerance) 
                count = count + 1;
            end
        end
        count;
        if (count > inliers)
            finalCoeff = coeff;
            inliers = count;
        end
    end
end


