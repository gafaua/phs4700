function [coup, vbf, t, rbt] = Devoir2(option, xy0, vb0, wb0)
	rbt = [xy0];
	vbf = [vb0];
	t = [0];

	deltaT = 0.5;
	i = 1;

	while true
		t(i+1) = t(i) + deltaT;

		% CALCULER ACCELERATION SELON LES FORCES
		accel = CalculerAcceleration(option);

		% CALCULER VITESSE SELON ACCELERATION
		vbf(i+1) = v(i) + accel * deltaT;

		% CALCULER POSITION SELON VITESSE
		rbt(i+1) = rbt(i) + vbf(i) * deltaT + 0.5 * accel * deltaT ^ 2;

		% VERIFIER POSITION BALLE
		pos = PositionBalle(rbt(i+1));

		if pos == "exterieur"
			fprintf('La balle est sortie du terrain \n');
			break;
		end

		if rbt(i+1, 3) <= 0
			fprintf('La balle a touché le sol en dehors du \n');
			break;
		end

		% TODO: CHECKER SI POSITION EST SUR LA COUPE HAUTEUR

		% UPDATE I
		i += 1
	end
	rbt
	t
	vbt
end

function accel = CalculerAcceleration(option) 
	m = 0.0459;
	g = 0.m * [0, 0, -9.8]; % GRAVITY
	accel = g / m; % a = F / m (deuxieme loi de newton)

	if option == 2
		% CALCULER AVEC GRAVI + VISQUEUX
	elseif option == 3
		% CALCULER AVEC GRAVI + VISQUEUX + MAGNUS
	end
end