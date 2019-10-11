classdef Positions
   enumeration
      exterieur, sol, coupe, air, vert
   end
end

function pos = SurVert(x, y, z)
    if ((x-Constantes.POSITION_COUPE_X)^2 + (y-Constantes.POSITION_COUPE_Y)^2 +...
    (z-(Constantes.VERT_HAUTEUR - Constantes.VERT_RAYON))^2) <=...
    (Constantes.VERT_RAYON + Constantes.BALLE_RAYON)^2
        pos = Positions.vert;
end

function pos = PositionDansTerrain(x, y, z)
    % verifier si la balle sort du terrain
    if x < 0 || y < 0 || x > 110 || y > 70 || (x > 60 && y < 45/50*x)
        pos = Positions.exterieur;
    % verifier si la balle rentre dans la coupe
    else if x > Constantes.POSITION_COUPE_X - Constantes.COUPE_RAYON &&...
            x < Constantes.POSITION_COUPE_X + Constantes.COUPE_RAYON &&...
            y > Constantes.POSITION_COUPE_Y - Constantes.COUPE_RAYON &&...
            y < Constantes.POSITION_COUPE_Y + Constantes.COUPE_RAYON &&...
            z <= Constantes.VERT_HAUTEUR
        pos = Positions.coupe;
    % si au sol: verifier si la balle est sur le sol
    else if y = Constantes.BALLE_RAYON
            
    end;
end;

