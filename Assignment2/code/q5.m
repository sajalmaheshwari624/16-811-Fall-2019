clear
clc

% -------    choose function for which to find root and initial values
f = @(x) x^3 - 5*x^2+ 11*x -15;
x_0 = -1;
x_1 = -1.05;
x_2 = -1.1;
[root, val] = mullerMethod(f, x_0, x_1, x_2);
disp ("First root :")
disp (root)

f = @(x) f(x)/(x - root);
x_0 = 2.0;
x_1 = 2.1;
x_2 = 2.2;
[root, val] = mullerMethod(f, x_0, x_1, x_2);
disp ("Second root :")
disp (root)

f = @(x) f(x)/(x - root);
x_0 = 2.0;
x_1 = 2.1;
x_2 = 2.2;
[root, val] = mullerMethod(f, x_0, x_1, x_2);
disp ("Third root :")
disp (root)

function [rootPoint, rootVal] = mullerMethod(f, x_0, x_1, x_2)
    precision = 0.00001;
    rootPoint = x_2;
    rootVal = f(rootPoint);
    while (abs(rootVal) > precision)
        f_x_0 = f(x_0);
        f_x_1 = f(x_1);
        f_x_2 = f(x_2);
        a = ((x_1 - x_0)*(f_x_2 - f_x_1) - (f_x_1 - f_x_0)*(x_2 - x_1)) / ...
            ((x_1 - x_0) * (x_2 - x_1) * (x_2 - x_0));
        b = (f_x_2 - f_x_1) / (x_2 - x_1) + a * (x_2 - x_1);
        x_3_pos = x_2 - (2 * f_x_2) / (b + sqrt(b * b - 4 * a * f_x_2));
        x_3_neg = x_2 - (2 * f_x_2) / (b - sqrt(b * b - 4 * a * f_x_2));
        f_x_3_pos = f(x_3_pos);
        f_x_3_neg = f(x_3_neg);
        if (abs(f_x_3_pos) < precision)
            rootVal = f_x_3_pos;
            rootPoint = x_3_pos;
        elseif (abs(f_x_3_neg) < precision)
            rootVal = f_x_3_neg;
            rootPoint = x_3_neg;
        else
            diff_x_pos = abs(x_3_pos - x_2);
            diff_x_neg = abs(x_3_neg - x_2);
            if (diff_x_pos > diff_x_neg)
                x_3 = x_3_neg;
                rootVal = f_x_3_neg;
                rootPoint = x_3;
            else
                x_3 = x_3_pos;
                rootVal = f_x_3_pos;
                rootPoint = x_3;
            end
        end
        x_0 = x_1;
        x_1 = x_2;
        x_2 = rootPoint;
    end
end

