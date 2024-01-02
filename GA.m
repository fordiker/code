clc; clear; close all;
radian0 = load('data.txt');
d1 = [0, 0]; 
x = radian0(:, 1:2:8);
x = x(:);
y = radian0(:, 2:2:8);
y = y(:);
radian = [x y]; 
xy = [d1; radian; d1]; 
radian = xy * pi / 180;  
distance = zeros(102); 
for i = 1:101
    for j = i + 1:102
        distance(i, j) = 6370 * acos(cos(radian(i, 1) - radian(j, 1)) * cos(radian(i, 2)) * ...
            cos(radian(j, 2)) + sin(radian(i, 2)) * sin(radian(j, 2)));
    end
end
distance = distance + distance';
number = 50; 
generation = 100; 
for k = 1:number  
    result = randperm(100);  
    result1 = [1, result + 1, 102]; 
    for t = 1:102 
        sign = 0; 
        for mi = 1:100
            for mj = mi + 2:101
                if distance(result1(mi), result1(mj)) + distance(result1(mi + 1), result1(mj + 1)) < ...
                        distance(result1(mi), result1(mi + 1)) + distance(result1(mj), result1(mj + 1))
                    result1(mi + 1:mj) = result1(mj:-1:mi + 1);  
                    sign = 1;
                end
            end
        end
        if sign == 0
            J(k, result1) = 1:102; 
            break;
        end
    end
end
J(:, 1) = 0; 
J = J / 102; 
for k = 1:generation   
    A = J; 
    result = randperm(number); 
    for i = 1:2:number  
        F = 2 + floor(100 * rand(1));
        temp = A(result(i), [F:102]); 
        A(result(i), [F:102]) = A(result(i + 1), [F:102]);
        A(result(i + 1), F:102) = temp;  
    end
    by = [];  
    while ~length(by)
        by = find(rand(1, number) < 0.1); 
    end
    B = A(by, :);
    for j = 1:length(by)
        address = sort(2 + floor(100 * rand(1, 3)));  
        B(j, :) = B(j, [1:address(1) - 1, address(2) + 1:address(3), address(1):address(2), address(3) + 1:102]); 
    end
    G = [J; A; B]; 
    [SG, ind1] = sort(G, 2); 
    num = size(G, 1); 
    long = zeros(1, num);
    for j = 1:num
        for i = 1:101
            long(j) = long(j) + distance(ind1(j, i), ind1(j, i + 1)); 
        end
    end
    [slong, ind2] = sort(long); 
    J = G(ind2(1:number), :); 
end
path = ind1(ind2(1), :);
flong = slong(1);
xx = xy(path, 1);
yy = xy(path, 2);
plot(xx, yy, '-o');
