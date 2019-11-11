function [pos, point, M] = Position(pos_bloc, pos_balle, t, w_bloc)
    [collision, point, M] = Collision(pos_bloc, pos_balle, t, w_bloc);
    if (collision)
        pos = 0;
    elseif BlocToucheSol(pos_bloc, t, w_bloc)
        pos = 1;
    elseif BalleToucheSol(pos_balle)
        pos = 1;
    else 
        pos = 2;
    end
end

function [collision, point, M] = Collision(pos_bloc, pos_balle, t, w_bloc)
    RC_bloc = 0.05196152422706632; # Distance entre CM du cube et son coin
    RC_balle = 0.02; # Rayon de la balle
    M = []; # Matrice de rotation du cube

    d = norm(pos_bloc - pos_balle);
    Rtot = RC_balle + RC_bloc;
    
    # Détection Sphère - Sphère englobant le cube
    if (d <= Rtot)
        % Detection de collision plus approfondie
        M = Rotation(t, w_bloc);
        c = 0.03; % Distance entre CM du cube et une des faces
        
        % Sommets S du cube
        S = [(M * [-c; -c; c])' + pos_bloc];
        S = [S; (M * [ c; -c;  c])' + pos_bloc];
        S = [S; (M * [ c;  c;  c])' + pos_bloc];
        S = [S; (M * [ c;  c; -c])' + pos_bloc];
        S = [S; (M * [-c; -c; -c])' + pos_bloc];
        S = [S; (M * [-c;  c; -c])' + pos_bloc];
        S = [S; (M * [ c; -c; -c])' + pos_bloc];
        S = [S; (M * [-c;  c;  c])' + pos_bloc];

        %Détection des collisions possibles avec les sommets du cube
        for idx=1:8
            if (CollisionPointSphere(S(idx, :), pos_balle))
                collision = 1;
                point = S(idx, :);
                return;
            end
        end
        
        %Détection des collisions possibles avec les arêtes du cube
        [collision, point] = CollisionAreteSphere(S(1, :), S(2, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(1, :), S(8, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(1, :), S(5, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(3, :), S(2, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(7, :), S(2, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(7, :), S(5, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(7, :), S(4, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(4, :), S(3, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(6, :), S(4, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(6, :), S(5, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(6, :), S(8, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionAreteSphere(S(8, :), S(3, :), pos_balle);
        if (collision) return; end

        %Détection des collisions possibles avec les faces du cube
        [collision, point] = CollisionPlanSphere(S(3, :), S(2, :), S(1, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionPlanSphere(S(5, :), S(1, :), S(2, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionPlanSphere(S(2, :), S(3, :), S(4, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionPlanSphere(S(4, :), S(6, :), S(5, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionPlanSphere(S(6, :), S(4, :), S(3, :), pos_balle);
        if (collision) return; end
        [collision, point] = CollisionPlanSphere(S(1, :), S(5, :), S(6, :), pos_balle);
        if (collision) return; end
    end 

    % Pas de collisions
    collision = 0;
    point = [0, 0, 0];
end

function Collision = CollisionPointSphere(P, pos_balle, r_balle = 0.02)
    %sphère: (x-pos[x])^2 + (y-pos[y])^2 + (z-pos[z])^2 <= r
    Collision = ((P(1) - pos_balle(1))^2 + (P(2) - pos_balle(2))^2 + (P(3) - pos_balle(3))^2) <= r_balle^2;
end

function [Collision, Point] = CollisionAreteSphere(P1, P2, pos_balle, r_balle = 0.02)
    u = P1 - P2;

    %En se basant sur l'équation de la sphère
    % et sur l'équation de la droite passant par P1 de vecteur directeur u
    a = (u(1))^2 + (u(2))^2 + (u(3))^2;
    b = 2*((u(1) * (P1(1) - pos_balle(1))) + (u(2) * (P1(2) - pos_balle(2))) + (u(3) * (P1(3) - pos_balle(3))));
    c = (P1(1) - pos_balle(1))^2 + (P1(2) - pos_balle(2))^2 + (P1(3) - pos_balle(3))^2 - r_balle^2;

    facteurs = roots([a b c]);
    if (isreal(facteurs))
        if (facteurs(1) == facteurs(2))
            Point = P1 + u * facteurs(1);
            Collision = PointSurArete(Point, P1, P2);
        else
            p_1 = P1 + u * facteurs(1);
            p_2 = P1 + u * facteurs(2);

            Point = [0, 0, 0];
            n = 0;

            if (PointSurArete(p_1, P1, P2))
                Point += p_1;
                n += 1;
            end

            if (PointSurArete(p_2, P1, P2))
                Point += p_2;
                n += 1;
            end

            if (n)
                Collision = n; %n = 2 implique que 2 points sont en collision avec l'arête, on prend alors le point milieu
                Point = Point / n;
            else
                Collision = 0;
            end
        end
    else
        Collision = 0;
        Point = [0, 0, 0];
    end
end

%P2 est toujours le coin de l'angle droit du triangle formé par P1 P2 P3
function [Collision, Point] = CollisionPlanSphere(P1, P2, P3, pos_balle, r_balle = 0.02)
    % Calcul de la normale n du plan et de la constante D de l'équation du plan
    n = cross(P1-P2, P1-P3);
    D = -(n(1)*P1(1) + n(2)*P1(2) + n(3)*P1(3));

    %En utilisant la droite passant par pos_balle de vecteur directeur n, trouver le point d'intersection
    t = (-D - (pos_balle(1)*n(1)) - (pos_balle(2)*n(2)) - (pos_balle(3)*n(3))) / (n(1)^2 + n(2)^2 + n(3)^2);
    %Point d'intersection P
    P = pos_balle + t * n;

    %Vérifier si le point est à l'intérieur des limites du bloc et dans ou sur la surface de la balle
    Collision = PointSurFace(P, P1, P2, P3) && CollisionPointSphere(P, pos_balle);

    if (Collision)
        Point = P;
    else
        Point = [0, 0, 0];
    end
end

function Entre = PointSurArete(P, P1, P2)
    norme_u = norm(P1-P2);

    Entre = norm(P1-P) < norme_u && norm(P2-P) < norme_u;
end

%Cette fonction prends en compte que P2 est le point de l'angle droit du triangle formé par P1 P2 P3
function Entre = PointSurFace(P, P1, P2, P3)
    P4 = P3 + (P1 - P2);
    norme_u = norm(P1 - P3);

    Entre = norm(P1-P) <= norme_u && norm(P2-P) <= norme_u && norm(P3-P) <= norme_u && norm(P4-P) <= norme_u;
end

function M = Rotation(t, w_bloc)
    rot = w_bloc * t;
    M_x = [1, 0,            0;...
           0, cos(rot(1)), -sin(rot(1));...
           0, sin(rot(1)),  cos(rot(1))];

    M_y = [cos(rot(2)), 0, sin(rot(2));...
           0,           1, 0;...
          -sin(rot(2)), 0, cos(rot(2))];

    M_z = [cos(rot(3)), -sin(rot(3)), 0;...
           sin(rot(3)),  cos(rot(3)), 0;...
           0,            0,           1];
    
    M = M_z * M_y * M_x;
end

function blocToucheSol = BlocToucheSol(pos_bloc, t, w_bloc)
    M = Rotation(t, w_bloc);
    c = 0.03;
    
    % Sommets S du cube
    S = [(M * [-c; -c;  c])' + pos_bloc];
    S = [S; (M * [c;  -c;  c])' + pos_bloc];
    S = [S; (M * [c;  c;   c])' + pos_bloc];
    S = [S; (M * [c;  c;  -c])' + pos_bloc];
    S = [S; (M * [-c; -c; -c])' + pos_bloc];
    S = [S; (M * [-c; c;  -c])' + pos_bloc];
    S = [S; (M * [c; -c;  -c])' + pos_bloc];
    S = [S; (M * [-c; c;  c])' + pos_bloc];

    blocToucheSol = false;

    % Détection des collisions possibles avec les sommets du cube
    for idx=1:8
        if (S(idx, 3) <= 0)
            blocToucheSol = true;
            return;
        end
    end
end

function balleToucheSol = BalleToucheSol(pos_balle)
    balleToucheSol = pos_balle(1,3) <= 0.02;
end