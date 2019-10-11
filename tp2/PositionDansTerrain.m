classdef Positions
   enumeration
      exterieur, sol, coupe, air, vert
   end
end

function pos = SurVert(x, y, z)
    if ((x-92)^2 + (y-53)^2 + (z-(Constantes.VERT_HAUTEUR - Constantes.VERT_RAYON))^2) <= Constantes.VERT_RAYON^2
        pos = Positions.vert;

end

function pos = PositionDansTerrain(x, y, z)
    % verifier si la balle sort du terrain
    if x < 0 || y < 0 || x > 110 || y > 70 || (x > 60 && y < 45/50*x)
        pos = Positions.exterieur;
    % verifier si la balle rentre dans la coupe
    else if x > 93 - Constantes.COUPE_RAYON && x < 93 + Constantes.COUPE_RAYON &&...
            y > 53 - Constantes.COUPE_RAYON && y < 53 + Constantes.COUPE_RAYON &&...
            z <= 3.5
        pos = Positions.coupe;
    % si au sol: verifier si la balle est sur le sol
    else if y = Constantes.BALLE_RAYON
            
    end;
end;