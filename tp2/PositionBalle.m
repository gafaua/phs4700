function pos = PositionBalle(rbt)
    if DansCoupe(rbt(1), rbt(2))
        pos = "coupe";
    elseif DansVert(rbt(1), rbt(2))
        pos = "vert";
    elseif Exterieur(rbt(1), rbt(2))
        pos = "exterieur";
    else
        pos = "terrain";
    end
    % EXPLIQUER QU'ON CHECK JUSTE LE CENTRE DE MASSE
end

function dansCoupe = DansCoupe(x, y)
    posX = (x - (110 - 18)) ^ 2;
    posY = (y - (70 - 17)) ^ 2;
    rayonC = 0.054 ^ 2;
    dansCoupe = (posX + posY <= rayonC);
    % DOIT ON CALCULER Z ?
end

function dansVert = DansVert(x, y)
    posX = (x - (110 - 18)) ^ 2;
    posY = (y - (70 - 17)) ^ 2;
    rayonC = 15 ^ 2;
    dansVert = (posX + posY <= rayonC);
    % DOIT ON CALCULER Z ?
end

function exterieur = Exterieur(x, y)
    exterieur = x < 0 || ...
                y < 0 || ...
                x > 110 || ...
                y > 70 || ...
                (x > 60 && y < 45/50 * (x - 60));
    % DOIT ON CALCULER Z?
end