function pos = Position(pos_bloc, pos_balle)
    if Collision(pos_bloc, pos_balle)
        pos = 0;
    elseif BlocToucheSol(pos_bloc)
        pos = 1;
    elseif BalleToucheSol(pos_balle)
        pos = 1;
    end
end

function collision = Collision(pos_bloc, pos_balle)
end

function blocToucheSol = BlocToucheSol(pos_bloc)
end

function balleToucheSol = BalleToucheSol(pos_balle)
end