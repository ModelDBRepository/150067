%CINEMATICADIRECTA	S-function it is used to compute accelerations and velocities of a
% manipulator.
%
% This S-función calculates the robot acceleration joints.The block entry is 
% the u vector whose components are positions and velocities of articular
% coordinates [q qd] and the robot object called RRed.
%
%               [sys,x0,str,ts] =CINDIR(t,x,u,flag,RRed)
%
% RRed is an n-axis robot object and describes the manipulator dynamics and 
% kinematics
%
% Implementation in Simulink.
%
% See also: ACCEL_H,ACCEL, ROBOT, ODE45.

%   2007 Niceto Luque Sola

function [sys,x0,str,ts] =CINDIR(t,x,u,flag,RRed)
	switch flag,

	case 0
		% initialize  robot dimensions
		[sys,x0,str,ts] = mdlInitializeSizes(RRed);	% Init
        
       
     case {3}
		% come here to calculate derivitives
		       
        q=[u(1:RRed.n)];% articular postitions vector
        qd=[u(RRed.n+1:2*RRed.n)];%articular velocities vector
        tau=[u(2*RRed.n+1:end)]; % external applied torque
        sys = accel(RRed,q,qd,tau);%inverse dynamic
        %sys=accel(RRed,u);
	case {1, 2, 4, 9}
		sys = [];
	end
%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes(RRed)
 
%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;
 
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = RRed.n;
sizes.NumInputs      = 3*RRed.n;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed
 
sys = simsizes(sizes);
 
%
% initialize the initial conditions
%
x0  = [];
 
%
% str is always an empty matrix
%
str = [];
 
%
% initialize the array of sample times
%
ts  = [0 0];
 
% end mdlInitializeSizes
