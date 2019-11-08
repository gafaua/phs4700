function pos = Position(pos_bloc, pos_balle, t, w_bloc)
    if Collision(pos_bloc, pos_balle, t, w_bloc)
        pos = 0;
    elseif BlocToucheSol(pos_bloc)
        pos = 1;
    elseif BalleToucheSol(pos_balle)
        pos = 1;
    else pos = 2;
    end
end

function collision = Collision(pos_bloc, pos_balle, t, w_bloc)
    RC_bloc = 0.37837;  #Distance entre CM du cube et son coin
    RC_balle = 0.02;

    d = det(pos_bloc - pos_balle);
    Rtot = RC_balle + RC_bloc;
    
    if (d <= Rtot)
        % TODO: Continuer avec detection de collision plus approfondi
        M = Rotation(t, w_bloc);

        %Sommets du cube nécessaires pour former les différents plans du cube
        A = M * [-0.03, -0.03,  0.03] + pos_bloc;
        B = M * [0.03,  -0.03,  0.03] + pos_bloc;
        C = M * [0.03,  0.03,   0.03] + pos_bloc;
        D = M * [0.03,  0.03,  -0.03] + pos_bloc;
        E = M * [-0.03, -0.03, -0.03] + pos_bloc;
        F = M * [-0.03, 0.03,  -0.03] + pos_bloc;

        Plan1 = CollisionPlan(A, B, C);
        Plan2 = CollisionPlan(A, B, E);
        Plan3 = CollisionPlan(B, C, D);
        Plan4 = CollisionPlan(D, E, F);
        Plan5 = CollisionPlan(C, D, F);
        Plan6 = CollisionPlan(A, E, F);
        
    end 

    collision = 0;
end

function Plan = CollisionPlan(P1, P2, P3)
    % Calcul de normal
    normal = cross(P1-P2, P1-P3);
    

end

function M = Rotation(t, w_bloc)
    M = [0,          -w_bloc[3], w_bloc[2];...
         w_bloc[3],  0,          -w_bloc[1];...
         -w_bloc[2], w_bloc[1],  0] * t;
end

function Collision = CollisionCoin(P, pos_balle, r_balle = 0.02)
    %sphère: (x-pos[x])^2 + (y-pos[y])^2 + (z-pos[z])^2 <= r
    Collision = ((P[1] - pos_balle[1])^2 + (P[2] - pos_balle[2])^2 + (P[3] - pos_balle[3])^2) <= r_balle;
end

function [Collision, Point] = CollisionArete(P1, P2, pos_balle, r_balle = 0.02)
    u = P1 - P2;
    
    a = u[1]^2 + u[2]^2 + u[3]^2;
    b = (2 * u[1] * (pos_balle[1] - P1[1])) + (2 * u[2] * (pos_balle[2] - P1[2])) + (2 * u[3] * (pos_balle[3] - P1[3]));
    c = (P1[1] - pos_balle[1])^2 + (P1[2] - pos_balle[2])^2 + (P1[3] - pos_balle[3])^2 - r_balle;

    coll = roots([a b c])
    Collision = isreal(coll)
    if (Collision)

    end
end

function blocToucheSol = BlocToucheSol(pos_bloc)
 
end

function balleToucheSol = BalleToucheSol(pos_balle)
    balleToucheSol = pos_balle(3,:) <= 0.02;
end