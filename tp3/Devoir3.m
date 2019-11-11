function [Touche, tf, blocf, ballef] = Devoir3(bloci, ballei, tl, idx = 1)
	dt = 0.001;
	[Touche, tf, blocf, ballef, rbt_cf, rbt_bf] = CalculerTrajectoire(bloci, ballei, tl, dt); % Solution initiale

	rbt0_bloc = blocf(1,:);
	rbt0_balle = ballef(1,:);
	rbt0 = [rbt0_bloc rbt0_balle];

	% Calcul d'erreur et méthode d'atteinte des critères de précision
	converg = 0;
	m=1;
	epsilon = [0.001, 0.001, 0.001, 0.001, 0.001, 0.001];
	while not(converg)
		dt = dt/2;
		m = m + 1;
		[Touche, tf, blocf, ballef, rbt_cf, rbt_bf] = CalculerTrajectoire(bloci, ballei, tl, dt); % Solution raffinée
		rbt_bloc = blocf(1,:);
		rbt_balle = ballef(1,:);
		rbt = [rbt_bloc rbt_balle];
		[converg Err]=ErrSol(rbt,rbt0,epsilon); % Verifier si l'erreur entre les deux solutions converge
		rbt0=rbt;
		if m>3
            break;
        end;
	end;
	
	rbt = rbt + Err / 15;
	blocf(1,:) = rbt(1:3);
	ballef(1,:) = rbt(4:6);
end


function [Touche, tf, blocf, ballef, rbt_cf, rbt_bf] = CalculerTrajectoire(bloci, ballei, tl, dt)
	% 3 étapes:
	% 1) Calculer cinématiques
	%    a) Calculer RK4 pour le bloc
	%    b) Calculer RK4 pour la balle
	% 2) Détecter collision
	%    a) Détecter collision entre balle et sphère bloc
	%    	a.a) Détecter collision entre balle et bloc
	%    b) Détecter collision sol
	%       b.a) Détecter collision balle-sol
	%       b.b) Détecter collision bloc-sol
	% 3) Calculer vitesses post-collision balle-bloc

	rbt_bloc = bloci(1,:);
	vbf_bloc = bloci(2,:);
	wb_bloc = bloci(3,:);

	rbt_balle = ballei(1,:);
	vbf_balle = ballei(2,:);

	t = [0];
	i = 1;

	pos = 2;
	point = [0, 0, 0];

	% Surface du bloc: 1.2 * A^2
	S_bloc = 1.2 * 0.06^2;
	
	% Surface de la balle: pi * r^2
	S_balle = pi * 0.02^2;

	% Tant qu'aucune collision n'a été détecté
	while (pos == 2)
		i += 1;
		t = [t; t(i-1) + dt];

		q_bloc = [vbf_bloc(i-1, :); rbt_bloc(i-1, :); wb_bloc];
		qf_bloc = RK4(q_bloc, dt, 0.58, S_bloc); % Runge-Kutta
		rbt_bloc = [rbt_bloc; qf_bloc(2, :)];
		vbf_bloc = [vbf_bloc; qf_bloc(1, :)];

		
		if (t(i-1) >= tl) % Si la balle a été lancée
			q_balle = [vbf_balle(i-1, :); rbt_balle(i-1, :); [0, 0, 0]];
			qf_balle = RK4(q_balle, dt, 0.07, S_balle);	% Runge-Kutta
			rbt_balle = [rbt_balle; qf_balle(2, :)];
			vbf_balle = [vbf_balle; qf_balle(1, :)];
		else 
			rbt_balle = [rbt_balle; rbt_balle(i-1, :)];
			vbf_balle = [vbf_balle; vbf_balle(i-1, :)];
		end

		[pos, point, M] = Position(rbt_bloc(i, :), rbt_balle(i, :), t(i), wb_bloc);
	end;

	if (pos == 0) % Collision détectée entre la balle et le bloc
		[vbf_blocf, wbf_bloc, vbf_ballef] = ApresCollision(rbt_bloc(i,:), rbt_balle(i,:), point, vbf_bloc(i,:), vbf_balle(i,:), wb_bloc, M);
		vbf_bloc(i,:) = vbf_blocf;
		wb_bloc = wbf_bloc;
		vbf_balle(i,:) = vbf_ballef;
	end;

	Touche = pos;
	tf = t(i);

	blocf = [rbt_bloc(i,:);...
			 vbf_bloc(i,:);...
			 wb_bloc];
	
	ballef = [rbt_balle(i,:);...
			  vbf_balle(i,:)];

	% Pour les graphes
	rbt_cf = rbt_bloc;
	rbt_bf = rbt_balle;
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
	sF = m * [0, 0, -9.8]; % Gravité
	sF += (-1 * S) * vb; % Force de frottement visqueux

 	% Deuxieme loi de newton
	accel = sF / m;
end

function [converg Err]=ErrSol(rbt1,rbt0,epsilon) 
	% Verification si solution convergee (inspire du document de reference sur moodle)
	% converg: variable logique pour convergence
	%          Err<epsilon pour chaque element
	% Err : Difference entre rbt1 et rbt0
	% rbt1: nouvelle solution
	% rbt0: ancienne solution
	% epsilon : précision
	Err=(rbt1-rbt0);
	nbelem = length(Err);
	converg = 1;
	for i=1:nbelem
		converg = converg & abs(Err(i)) < epsilon(i);
	end
end
