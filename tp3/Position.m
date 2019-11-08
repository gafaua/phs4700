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

function Plan = CollisionPlan(P1, P2, P3, pos_balle)
    RC_balle = 0.02;
    
    % Calcul de normal
    normal = cross(P1-P2, P1-P3);

    % Vecteur unitair normal
    vu_normal = normal / sqrt(normal(1,:)^2 + normal(2,:)^2 + normal(3,:)^2);
    
    
    
    % P = [x, y, z]
    % plan = normal * P'
    

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
    
    %En se basant sur l'équation de la sphère
    % et sur l'équation de la droite passant par P1 de vecteur directeur u
    a = u[1]^2 + u[2]^2 + u[3]^2;
    b = (2 * u[1] * (pos_balle[1] - P1[1])) + (2 * u[2] * (pos_balle[2] - P1[2])) + (2 * u[3] * (pos_balle[3] - P1[3]));
    c = (P1[1] - pos_balle[1])^2 + (P1[2] - pos_balle[2])^2 + (P1[3] - pos_balle[3])^2 - r_balle;

    facteurs = roots([a b c])
    if (isreal(coll))
        if (facteurs[1] == facteurs[2])
            Point = P1 + u * facteurs[1];
            Collision = PointEntrePoints(Point);
        else    %Probleme TODO: figure out quoi faire si deux points sont en intersection avec une arete
            p_1 = P1 + u * facteurs[1];
            p_2 = P1 + u * facteurs[2];

            if (PointEntrePoints(p_1))
                if (PointEntrePoints(p_2)) %intersection de 2 points sur l'arete, point milieu?
                    Point = (p_1 + p_2) / 2;
                    Collision = 1; 
                else
                    Point = p_1;
                    Collision = 1;
                end
            elseif(PointEntrePoints(p_2))
                Point = p_2;
                Collision = 1;
            else
                Collision = 0;
            end
        end
    else
        Collision = 0;
    end
end

function Entre = PointEntrePoints(P, P1, P2)
    norme_u = norm(P1-P2);
    norme_v_1 = norm(P1-P);
    norme_v_2 = norm(P2-P);
    
    Entre = norme_v_1 < norme_u && norme_v_2 < norme_u;
end

function blocToucheSol = BlocToucheSol(pos_bloc)
 
end

function balleToucheSol = BalleToucheSol(pos_balle)
    balleToucheSol = pos_balle(3,:) <= 0.02;
end