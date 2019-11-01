function [Touche, tf, blocf, ballef] = Devoir3(bloci, ballei, tl)

dt = 0.001;
[Touche, tf, blocf, ballef] = CalculerTrajectoire(bloci, ballei, tl, dt); % Solution 1

end


function [Touche, tf, blocf, ballef] = CalculerTrajectoire(bloci, ballei, tl, dt)
	rbt_bloc = bloci(1,:);
	vbf_bloc = bloci(2,:);
    wb0_bloc = bloci(3,:)
	t = [0];
	i = 2;
	pos = 4;
	while (pos == 4)
		t = [t; t(i-1) + dt];
		q = [vbf(i-1, :); rbt(i-1, :); wb0'];
		qf = RK4(option, q, dt);	%Runge-Kutta

		rbt = [rbt; qf(2, :)];
		vbf = [vbf; qf(1, :)];

		% Vérifier position balle
		pos = PositionBalle(rbt(i, :));
		i += 1;
	end;
	coup = pos;
	vbf = vbf(i-1, :);
end;

function qf = RK4(option, q, dt)
	%k1 = g(q(tn-1), tn-1)
	k1 = g(option, q, 0);
	%k2 = g(q(tn-1) + deltaT/2 * k1, tn-1 + deltaT/2)
	k2 = g(option, q + k1 * dt/2, dt/2);
	%k3 = g(q(tn-1) + deltatT/2 * k2, tn-1 + deltaT/2)
	k3 = g(option, q + k2 * dt/2, dt/2);
	%k4 = g(q(tn-1) + deltaT * k3, tn-1 + deltaT)
	k4 = g(option, q + k3 * dt, dt);

	qf = q + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
end

function g = g(option, q, dt)
	a = CalculerAcceleration(option, q(1, :), q(3,:));
	v = q(1,:) + a * dt;
	g = [a; v; [0, 0, 0]];
end

function accel = CalculerAcceleration(option, vb, wb) 
	m = 0.0459;
	sF = m * [0, 0, -9.8]; % GRAVITE

	if option >= 2
		A = pi * (0.02135 ^ 2);
		p = 1.2;
		Cv = 0.14;
		sF += (-p * Cv * A / 2) * norm(vb) * vb; % FROTTEMENT VISQUEUX
	end

	% if option == 3
	% 	Cm = 0.000791 * norm(wb);
	% 	part1 = (p * Cm * A / 2) * (norm(vb) ^ 2);
	% 	crossb = cross(wb, vb);
	% 	part2 = crossb / norm(crossb);
	% 	sF += part1 * part2; % MAGNUS
	% end

	accel = sF / m; % a = F / m (deuxieme loi de newton)
end