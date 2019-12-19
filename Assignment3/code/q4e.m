clear
clc

%% Code for part E
clutter_hallway_data = load('cluttered_hallway.txt');
xMin = min(clutter_hallway_data(:,1));
xMax = max(clutter_hallway_data(:,1));
yMin = min(clutter_hallway_data(:,2));
yMax = max(clutter_hallway_data(:,1));

plot3(clutter_hallway_data(:,1), clutter_hallway_data(:,2), clutter_hallway_data(:,3))
hold on

coeffPlane1 = ransac(clutter_hallway_data, 1000, 0.0029, 0);
planeIndices = checkPointInPlane(coeffPlane1,0.01, clutter_hallway_data);
roughness = var(planeIndices)/numel(planeIndices)
clutter_hallway_data(planeIndices,:) = [];

coeffPlane2 = ransac(clutter_hallway_data, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane2,0.01, clutter_hallway_data);
roughness = var(planeIndices)/numel(planeIndices)
clutter_hallway_data(planeIndices,:) = [];

mean_clutter_points = mean(clutter_hallway_data);
clutter_points_x = clutter_hallway_data(:,1);
side_1_indices = find(clutter_points_x > mean_clutter_points(1));
side_2_indices = find(clutter_points_x <= mean_clutter_points(1));
clutter_side_1 = clutter_hallway_data(side_1_indices,:);
clutter_side_2 = clutter_hallway_data(side_2_indices,:);
coeffPlane4 = zeros(size(clutter_side_2));
for i=1:1:size(clutter_side_2,1)
    planarIndices = knnsearch(clutter_side_2, clutter_side_2(i,:), 'K',4);
    planarIndices = planarIndices(2:end);
    planarPoints = clutter_side_2(planarIndices,:)';
    vecInPlane1 = planarPoints(3,:) - planarPoints(1,:);
    vecInPlane2 = planarPoints(2,:) - planarPoints(1,:);
    vectorNormal = cross(vecInPlane1, vecInPlane2);
    bias = sum(vectorNormal*planarPoints(:,3));
    cTerm = vectorNormal(3);
    if (cTerm ~= 0)
        coeffPlane4(i,1) = -1*vectorNormal(1)/cTerm;
        coeffPlane4(i,2) = -1*vectorNormal(2)/cTerm;
        coeffPlane4(i,3) = 1*bias/cTerm;
    end
end
coeffPlane3 = ransac(clutter_side_1, 1000, 0.0029, 0)
planeIndices = checkPointInPlane(coeffPlane3,0.01, clutter_side_1);
roughness = var(planeIndices)/numel(planeIndices)
coeffPlane4 = mode(coeffPlane4)
planeIndices = checkPointInPlane(coeffPlane4,0.01, clutter_side_2);
roughness = var(planeIndices)/numel(planeIndices)

[x1,y1] = meshgrid(xMin:0.01:xMax, yMin:0.01:yMax);
z1 = coeffPlane1(1)*x1 + coeffPlane1(2)*y1 + coeffPlane1(3);
z2 = coeffPlane2(1)*x1 + coeffPlane2(2)*y1 + coeffPlane2(3);
z3 = coeffPlane3(1)*x1 + coeffPlane3(2)*y1 + coeffPlane3(3);
z4 = coeffPlane4(1)*x1 + coeffPlane4(2)*y1 + coeffPlane4(3);
%z5 = coeffPlane5(1)*x1 + coeffPlane5(2)*y1 + coeffPlane5(3);
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
    pointIndices;
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

function[finalCoeff] = smoothRansac(dataPoints, iter, tolerance, inliers)
    num_examples = size(dataPoints, 1);
    for i=1:1:iter
        randCombination = randperm(num_examples);
        ransacInputIndex = randCombination(1:360);
        x = mean(dataPoints(ransacInputIndex(1:120),1));
        y = mean(dataPoints(ransacInputIndex(121:240),2));
        z = mean(dataPoints(ransacInputIndex(241:360),3));
        A = [x,y,ones(size(z))];
        coeff = A\z;
        xEval = dataPoints(randCombination(361:end),1);
        yEval = dataPoints(randCombination(361:end),2);
        zEval = dataPoints(randCombination(361:end),3);
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