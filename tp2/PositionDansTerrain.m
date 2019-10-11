function pos = PositionDansTerrain(x, y, z)
	% verifier si la balle sort du terrain
	if x < 0 || y < 0 || x > 110 || y > 70 || (x > 60 && y < 45/50*(x-60))
		pos = "exterieur";
	% verifier si la balle rentre dans la coupe
	elseif x > (Constantes.POSITION_COUPE_X - Constantes.COUPE_RAYON) && ...
			x < (Constantes.POSITION_COUPE_X + Constantes.COUPE_RAYON) && ...
			y > (Constantes.POSITION_COUPE_Y - Constantes.COUPE_RAYON) && ...
			y < (Constantes.POSITION_COUPE_Y + Constantes.COUPE_RAYON) && ...
			z <= Constantes.VERT_HAUTEUR
		pos = "coupe";
	% verifier si la balle est sur le sol
	elseif z <= Constantes.BALLE_RAYON || ...
			((x-Constantes.POSITION_COUPE_X)^2 + (y-Constantes.POSITION_COUPE_Y)^2 + ...
			(z-(Constantes.VERT_HAUTEUR - Constantes.VERT_SPHERE_RAYON))^2) <= ...
			(Constantes.VERT_SPHERE_RAYON + Constantes.BALLE_RAYON)^2
		pos = "vert";
	else pos = "air";
	end
end