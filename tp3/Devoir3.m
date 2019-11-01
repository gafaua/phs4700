function [Touche, tf, blocf, ballef] = Devoir3(bloci, ballei, tl)

	dt = 0.001;
	[Touche, tf, blocf, ballef] = CalculerTrajectoire(bloci, ballei, tl, dt); % Solution 1

end


function [Touche, tf, blocf, ballef] = CalculerTrajectoire(bloci, ballei, tl, dt)
	rbt_bloc = bloci(1,:);
	vbf_bloc = bloci(2,:);
    wb0_bloc = bloci(3,:)

	rbt_balle = ballei(1,:);
	vbf_balle = ballei(2,:);
	S_balle = CalculerAcceleration();

	t = [0];
	i = 1;
	pos = 2;

	S_bloc = 1.2 * 0.06^2;
	S_balle = pi * 0.02^2;

	while (pos == 2)
		i += 1;
		t = [t; t(i-1) + dt];

		q_bloc = [vbf_bloc(i-1, :); rbt(i-1, :); wb0_bloc];
		qf_bloc = RK4(q_bloc, dt, 0.58, S_bloc); %Runge-Kutta
		rbt_bloc = [rbt_bloc; qf_bloc(2, :)];
		vbf_bloc = [vbf_bloc; qf_bloc(1, :)];

		if (t[i-1] >= tl)
			q_balle = [vbf_balle(i-1, :); rbt(i-1, :); [0, 0, 0]];
			qf_balle = RK4(q_balle, dt, 0.07, S_balle);	%Runge-Kutta
			rbt_balle = [rbt; qf_balle(2, :)];
			vbf_balle = [vbf; qf_balle(1, :)];
		end

		% Vérifier position balle & bloc
		pos = Position(rbt_bloc(i, :));
	end;

	if (pos == 0) %collision!
		%TODO calculer les nouvelles vitesses, angulaires et pas angulaires
	end;
	
	Touche = pos;
	tf = t[i];
	vbf = vbf(i-1, :);
end;

function qf = RK4(q, dt, m, S)
	%k1 = g(q(tn-1), tn-1)
	k1 = g(q, 0, m, S);
	%k2 = g(q(tn-1) + deltaT/2 * k1, tn-1 + deltaT/2)
	k2 = g(q + k1 * dt/2, dt/2, m, S);
	%k3 = g(q(tn-1) + deltatT/2 * k2, tn-1 + deltaT/2)
	k3 = g(q + k2 * dt/2, dt/2, m, S);
	%k4 = g(q(tn-1) + deltaT * k3, tn-1 + deltaT)
	k4 = g(q + k3 * dt, dt, m, S);

	qf = q + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
end

function g = g(q, dt, m, S)
	a = CalculerAcceleration(q(1, :), m, S);
	v = q(1,:) + a * dt;
	g = [a; v; [0, 0, 0]];
end

function accel = CalculerAcceleration(vb, m, S)
	sF = m * [0, 0, -9.8]; % GRAVITE
	sF += (-1 * S) * vb;

	accel = sF / m; % a = F / m (deuxieme loi de newton)
end
