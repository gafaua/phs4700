function pos = PositionBalle(rbt)
    if DansVert(rbt(1), rbt(2), rbt(3))
        if DansCoupe(rbt(1), rbt(2))
            pos = 0; % COUPE
        else
            pos = 1; % VERT
        end
    elseif Exterieur(rbt(1), rbt(2))
        pos = 3; % EXTERIEUR
    elseif Terrain(rbt(3))
        pos = 2; % TERRAIN
    else
        pos = 4; % ENCORE DANS LES AIRS
    end
end

function dansCoupe = DansCoupe(x, y)
    posX = (x - (110 - 18));
    posY = (y - (70 - 17));
    rayonC = 0.054;
    dansCoupe = (posX^2 + posY^2 <= rayonC^2);
end

function dansVert = DansVert(x, y, z)
    R = 237.25 / 7; % RAYON DE LA SPHERE TOTALE
    posX = (x - (110 - 18));
    posY = (y - (70 - 17));
    posZ = (z - (3.5 - R));
    dansVert = (posX^2 + posY^2 + posZ^2 <= (R + 0.02135)^2);
end

function exterieur = Exterieur(x, y)
    exterieur = x < 0 || ...
                y < 0 || ...
                x > 110 || ...
                y > 70 || ...
                (x > 60 && y < 45/50 * (x - 60));
end

function terrain = Terrain(z)
    terrain = (z <= 0.02135);
end