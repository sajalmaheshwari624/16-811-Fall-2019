clear
clc

xAngle = rand(1) * 360;
yAngle = rand(1) * 360;
zAngle = rand(1) * 360;

Rx = rotx(xAngle);
Ry = roty(yAngle);
Rz = rotz(zAngle);

R = Rz*Ry*Rx;

N = 50;
pPoints = rand(3,N) * 10; %% N points randomly initialized to be in (0,10)
translationGiven = (rand(3,1) - 0.5) * 10; %% Translation vector which can change the positions of the points in ...
%the range -5 to 5.
%qPoints = R*pPoints;
qPoints = R*pPoints + translationGiven;

%%%% Verification
averageP = mean(pPoints, 2);
averageQ = mean(qPoints, 2);
pZeroCentered = pPoints - averageP;
qZeroCentered = qPoints - averageQ;

MMat = pZeroCentered*(qZeroCentered)';
[U, S, V] = svd(MMat);
RotationCalc = V*U';
qNew = RotationCalc * pPoints;

translationCalc = averageQ - mean(RotationCalc*pPoints,2);

disp ("Rotation Error")
RotationCalc - R

disp ("Translation Error")
translationCalc - translationGiven