% 5 jun 2013 - Niceto R. Luque
% Direct Kinematics for a three joints robot
% 8-shaped trajectory
clear all; clc;
step = 0.002;
t = 0:step:1.00;

% joint positions 
qt2 = [];
qt3 = [];
qt1 = [];
delta = [];
% joint velocities
qvt2 = [];
qvt3 = [];
qvt1 = [];
% joint acceleration
qat2 = [];
qat3 = [];
qat1 = [];


l1 = 0.310; 
l2 = 0.4;
l3 = 0.390;

% cartesian coordinates
y = 0.1 * sin(2*pi * t)+0.21502;
z = 0.1 * sin(4 * pi * t)+0.18502;
x = ones(1, length(t)) * 0.5;
for i = 1:length(x),
    delta = [delta asin((sqrt((x(1,i).^2 + y(1,i).^2)) / (sqrt((x(1,i).^2 + y(1,i).^2)+(z(1,i)-l1)^2))))];
    qt1 = [qt1 (atan(y(1,i) / x(1,i)))];
    qt2 = [qt2 (-delta(1,i) + asin((x(1,i).^2 + y(1,i).^2 + (l2^2) - (l3^2) + (z(1,i) - l1)^2) / (2*l2*sqrt((x(1,i).^2 + y(1,i).^2)+(z(1,i) - l1).^2))))];
    qt3 = [qt3 (-delta(1,i) - qt2(1,i) + asin((x(1,i).^2 + y(1,i).^2 - (l2^2) + (l3^2) + (z(1,i) - l1).^2) / (2*l3*sqrt((x(1,i).^2 + y(1,i).^2)+(z(1,i) - l1).^2))))];
end

% the first link moves along qt3 trajectory (qt3) and the last two links along the same trajectory (qt2)

qt = [t;  qt1; qt2; qt3];
save('qt.mat','qt');

%joint velocities computation
for i = 1:(length(x)-1),
    qvt1 = [qvt1 ((qt1(1,i+1) - qt1(1,i)) / step)];
    qvt2 = [qvt2 ((qt2(1,i+1) - qt2(1,i)) / step)];
    qvt3 = [qvt3 ((qt3(1,i+1) - qt3(1,i)) / step)];
end    
%joint acceleration computation
for i=1:(length(x)-2),
    qat1 = [qat1 ((qvt1(1,i+1) - qvt1(1,i)) / step)];
    qat2 = [qat2 ((qvt2(1,i+1) - qvt2(1,i)) / step)];
    qat3 = [qat3 ((qvt3(1,i+1) - qvt3(1,i)) / step)];
end
% velocities start from zero
qvt1 = [0 qvt1];
qvt2 = [0 qvt2];
qvt3 = [0 qvt3];
%acceleration start from zero
qat1=[0 0 qat1];
qat2=[0 0 qat2];
qat3=[0 0 qat3];
qvt = [t; qvt1; qvt2; qvt3];
qat=[t;qat1;qat2;qat3];
save('qvt.mat','qvt');
save('qat.mat','qat');
%plot(qvt3,qvt2);
%clear all;
grid on
figure ()
plot3(qt1,qt2,qt3);
figure()
hold on
plot3(x,y,z);
grid on

