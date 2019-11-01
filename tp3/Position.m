function pos = Position(pos_bloc, pos_balle, t, w_bloc)
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
    RC_bloc = 0.37837;  #Distance entre CM du cube et son coin
    RC_balle = 0.02;

    d = det(pos_bloc - pos_balle);
    Rtot = RC_balle + RC_bloc;
    
    if (d <= Rtot)
        % TODO: Continuer avec detection de collision plus approfondi
    end 

    collision = 0;
end

function M = Rotation(t, w_bloc)
    M = [0          -w_bloc[3] w_bloc[2];...
         w_bloc[3]  0          -w_bloc[1];...
         -w_bloc[2] w_bloc[1]  0] * t;
end

function blocToucheSol = BlocToucheSol(pos_bloc)
end

function balleToucheSol = BalleToucheSol(pos_balle)
end