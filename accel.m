%ACCEL Compute manipulator forward dynamics
%
%	QDD = ACCEL(ROBOT, Q, QD, TORQUE)
%	QDD = ACCEL(ROBOT, [Q QD TORQUE])
%
% Returns a vector of joint accelerations that result from applying the 
% actuator TORQUE to the manipulator ROBOT in state Q and QD.
%
% Uses the method 1 of Walker and Orin to compute the forward dynamics.
% The accelerations of the coordinates are obtained first 
% with the method of Walker-Orin and, later,it is joining to obtain speed and position.  

% This form is useful for simulation of manipulator dynamics, in
% conjunction with a numerical integration function.
%
% Walker and Orin is a numerical method used to obtain the acceleration of the
% articular coordinates from the torque vector.For it, Newton-Euler's
% algorithm uses when articular aceleration is zero
% B= 0+H(q,q')+C(q); tau=D(q)q''+B; q''=inv(D(q))[tau-B]

% See also: RNE, ROBOT, ODE45.

% MOD HISTORY
% 4/99 add object support
% 1/02 copy rne code from inertia.m to here for speed
% % General cleanup of code: help comments, see also, copyright, remnant dh/dyn
% references, clarification of functions.
%
% 
%   1999 Peter I. Corke
%   2007 Niceto Luque Sola
function qdd = accel(robot, Q, qd, torque)
	n = robot.n;

	if nargin == 2,
	        q = Q(1:n);
		qd = Q(n+1:2*n);
		torque = Q(2*n+1:3*n);
	else
		q = Q;
		if length(q) == robot.n,
			q = q(:);
			qd = qd(:);
		end
	end

	%   compute current manipulator inertia
	%   torques resulting from unit acceleration of each joint with
	%   no gravity.
	M = frne(robot, ones(n,1)*q', zeros(n,n), eye(n), [0;0;0]);

	%    compute gravity and coriolis torque
	%    torques resulting from zero acceleration at given velocity &
	%    with gravity acting.
	tau = frne(robot, q', qd', zeros(1,n));	

	qdd = feval(@inv, M) * (torque(:) - tau'); %using builtin function

