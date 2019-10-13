function [coup, vbf, t, rbt] = Devoir2(option, xy0, vb0, wb0)
	rbt = [xy0; 0]';
	vbf = [vb0]';
	t = [0];

	deltaT = 0.001;
	i = 1;

	while true
		t = [t; t(i) + deltaT];

		% CALCULER ACCELERATION SELON LES FORCES
		accel = CalculerAcceleration(option, vbf(i,:), wb0');

		% CALCULER VITESSE SELON ACCELERATION
		vf = vbf(i,:) + accel * deltaT;
		vbf = [vbf; vf];

		% CALCULER POSITION SELON VITESSE
		rbtf = rbt(i, :) + vbf(i, :) * deltaT + 0.5 * accel * deltaT ^ 2;
		rbt = [rbt; rbtf];

		% VERIFIER POSITION BALLE
		pos = PositionBalle(rbtf);

		if pos == 3 || rbt(i+1, 3) <= 0
			coup = pos;
			break;
		end

		% TODO: CHECKER SI POSITION EST SUR LA COUPE HAUTEUR

		i += 1
	end
end

function accel = CalculerAcceleration(option, vb, wb) 
	m = 0.0459;
	sF = m * [0, 0, -9.8]; % GRAVITY

	if option >= 2
		A = pi * (0.02135 ^ 2);
		p = 1.2;
		Cv = 0.14;
		sF += (-p * Cv * A / 2) * norm(vb) * vb; % VISQUEUX
	end

	if option == 3
		Cm = 0.000791 * norm(wb);
		part1 = (p * Cm * A / 2) * (norm(vb) ^ 2);
		crossb = cross(wb, vb);
		part2 = crossb / norm(crossb);
		sF += part1 * part2; % MAGNUS
	end

	accel = sF / m; % a = F / m (deuxieme loi de newton)
end