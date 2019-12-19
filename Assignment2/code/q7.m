clear
clc

syms x y
p = 2*x^2 + 2*y^2 + 4*x + 4*y + 3;
q = x^2 + y^2 + 2*x*y + 3*x + 5*y + 4;

coeffP = [coeffs(p, y),0];
coeffQ = [coeffs(q, y),0];

coeffPRolled = [0, coeffs(p,y)];
coeffQRolled = [0, coeffs(q,y)];
precision = 0.00001;
disp ("Sylvester matrix : ")
SylvesterMatX = [coeffP;coeffPRolled;coeffQ;coeffQRolled]
disp ("Sylvester matrix determinant: ")
detSylvester = det(SylvesterMatX)
eqn = detSylvester == 0;
disp ("Root of determinant of Sylvester Matrix : ")
valuesX = double(vpa(solve(eqn, x, 'Real', 1)))

figure
hold on
for i=1:1:numel(valuesX)
    valuesY = [];
    xVal = valuesX(i);
    pNew = subs(p, [x,y], [xVal,y]);
    eqn = pNew == 0;
    valueY = double(vpa(solve(eqn, y, 'Real', 1)));
    for j=1:1:numel(valueY)
        qNew = subs(q, [x,y], [xVal,valueY(j)]);
        if (abs(qNew) < precision)
            output = [xVal, valueY(j)]
            scatter(xVal, valueY(j), 'r')
            scatter(xVal, valueY(j), 'r')
            plot(xVal, 0, '*')
        end
    end
end

ezplot(p)
hold on
ezplot(q)
hold off
hold on