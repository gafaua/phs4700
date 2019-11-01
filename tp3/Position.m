function pos = Position(pos_bloc, pos_balle)
    if Collision(pos_bloc, pos_balle)
        pos = 0;
    elseif BlocToucheSol(pos_bloc)
        pos = 1;
    elseif BalleToucheSol(pos_balle)
        pos = 1;
    else pos = 2;
    end
end

function collision = Collision(pos_bloc, pos_balle)
    RC_bloc = sqrt(sqrt(0.03^2 + 0.03^2) + 0.03^2);
    RC_balle = 0.02;

    d = det(pos_bloc - pos_balle);
    Rtot = RC_balle + RC_bloc;
    
    if (d <= Rtot)
        % TODO: Continuer avec detection de collision plus approfondi
    end 

    collision = 0;
end

function blocToucheSol = BlocToucheSol(pos_bloc)
end

function balleToucheSol = BalleToucheSol(pos_balle)
end