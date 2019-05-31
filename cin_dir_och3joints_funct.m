% 5 jun 2013 - Niceto R. Luque
% Direct Kinematics for a three joints robot
% 8-shaped trajectory
function [x1, y1, z1] = cin_dir_och3joints_funct(qt1,qt2,qt3)
syms q1 q2 q3 l1 l2 l3 x y z
A01=[cos(q1) 0 sin(q1) 0;sin(q1) 0 -cos(q1) 0;0 1 0 l1; 0 0 0 1];
A12=[cos(q2) -sin(q2) 0 l2*cos(q2); sin(q2) cos(q2) 0 l2*sin(q2);0 0 1 0; 0 0 0 1];
A23=[cos(q3) -sin(q3) 0 l3*cos(q3); sin(q3) cos(q3) 0 l3*sin(q3);0 0 1 0; 0 0 0 1];
A03=A01*A12*A23;
A03b=simple(A03);
x=A03b(1,4);
y=A03b(2,4);
z=A03b(3,4);


step = 0.002;
t = 0:step:(step*(length(qt1)-1));
% joint positions 
x1=[];
y1=[];
z1=[];

lr1 = 0.310; 
lr2 = 0.4;
lr3 = 0.390;

x1=subs(x,{q1,q2,q3,l1,l2,l3},{qt1,qt2,qt3,lr1,lr2,lr3});
y1=subs(y,{q1,q2,q3,l1,l2,l3},{qt1,qt2,qt3,lr1,lr2,lr3});
z1=subs(z,{q1,q2,q3,l1,l2,l3},{qt1,qt2,qt3,lr1,lr2,lr3});

