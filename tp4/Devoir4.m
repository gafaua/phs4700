function [xi,yi,zi,face] = Devoir4(nout, nin, dep)

    # Etapes
    # 1) Commencer au milieu
    # 2) Shift a gauche jusqu'a ce que le rayon ne touche plus l'ellipsoide
    # 3) Shift a droite """""""""""""""""""""""""""""""""""""""""""""""""
    # 4) Shift en haut/ et repeter gauche/droite
    # 5) Mm chose en bas
    
    [xi, yi, zi, face] = ScannerZ(nout, nin, dep)
end

function [xi, yi, zi, face] = ScannerZ(nout, nin, dep)
    z = 11;
    dz = 0
    while RayonToucheEllispoide(dep, [4, 4, z])(1)
        [xi_, yi_, zi_, face_] = ScannerPlanXY(nout, nin, dep, z);
        xi = [xi, xi_];
        xi = [yi, yi_];
        xi = [zi, zi_];
        face = [face, face_];
        z += dz;
    end
    z = 11;
    while RayonToucheEllispoide(dep, [4, 4, z])(1)
        [xi_, yi_, zi_, face_] = ScannerPlanXY(nout, nin, dep, z);
        xi = [xi, xi_];
        xi = [yi, yi_];
        xi = [zi, zi_];
        face = [face, face_];
        z -= dz;
    end
end

function [xi, yi, zi, face] = ScannerPlanXY(nout, nin, dep, z)
    # On commence avec le plan milieu
    x_initial = 4;
    y_initial = 4;

    # Vecteur directeur
    vdir = [x_initial, y_initial, z];
    
    # Delta directeur
    ds = 0.1;
    
    points = []; # Matrice contenant nos [xi, yi, zi, face] pour chaque point_contact.
    
    [collision, point_col] = RayonToucheEllispoide(dep, vdir)
    # On scan en se déplaçant vers les y négatifs tant que l'on touche l'ellipse.
    while (collision)
        # 1) Trouver réfraction
        # 2) Trouver nouvelle trajectoire rayon
        # 3) Détecter collision
        #   a) Si bloc -> Dérouler et ajouter [xi, yi, zi, face] à points
        #   b) Si ellipse, trouver réfraction et nouvelle trajectoire
        #       b1) Si dehors, sortir
        #       b2) Si dedans, continuer récursivement jusqu'à collision ou n = 100
        # 4) Décrementer y
        
        [reflexion, nouveau_vdir] = CalculerNouvelleTrajectoire(point_col - dep, point_col, nout, nin);
        if (!reflexion) %Le rayon lumineux rentre dans l'ellipsoide

            [coll_bloc, coord] = TrajectoireDansEllispsoide(dep, point_col, nouveau_vdir, nin, nout);

            if (coll_bloc)
                points = [points; coord];
            end
        end

        # Etape finale pour passer à next while step
        vdir = [x_initial, vdir(2) - ds, z];
        [collision, point_col] = RayonToucheEllispoide(dep, vdir)
    end

    # On retourne au centre
    vdir = [x_initial, y_initial, z];

    [collision, point_col] = RayonToucheEllispoide(dep, vdir)

    ## TODO PART BOTTOM
    # On scan en se déplaçant vers les x négatifs tant que l'on touche l'ellipse.
    while (collision)
        # 1) Trouver réfraction
        # 2) Trouver nouvelle trajectoire rayon
        # 3) Détecter collision
        #   a) Si bloc -> Dérouler et ajouter [xi, yi, zi, face] à points
        #   b) Si ellipse, trouver réfraction et nouvelle trajectoire
        #       b1) Si dehors, sortir
        #       b2) Si dedans, continuer récursivement jusqu'à collision ou n = 100

        # 4) Décrementer x
        vdir = [vdir(1) - ds, y_initial, z];
    end
end 


function [coll_bloc, coord] = TrajectoireDansEllispsoide(depart, point, vecteur_directeur, nin, nout)
    
    point1 = point;
    vdir = vecteur_directeur;

    distance_totale = norm(point - depart);    %On commence à mesurer la distance totale parcourue par le rayon
    
    for n=1:100
        [coll, point2] = RayonCollisionInterne(point1, vdir);

        distance_totale += norm(point2 - point1);

        if (coll)   %collision avec le bloc, ajoute le nouveau point et on arrête
            coll_bloc = true;
            nouveau_point = DeroulerRayon(depart, vdir, distance_totale);
            coord = [nouveau_point(1), nouveau_point(2), nouveau_point(3), coll];
            
            return;
        else        %collision avec l'ellipsoide, on arrête si le rayon sort de l'ellispoide
            [reflexion, vdir] = CalculerNouvelleTrajectoire(point2 - point1, point2, nin, nout);
            
            if (!reflexion)
                break;
            end

            point1 = point2;
        end
    end

    coll_bloc = false;
    coord = [0, 0, 0, 0];
end


%p: point_contact par lequel passe le rayon (position de l'observateur)
%nouveau_vdir: vecteur directeur de la droite
%interne: si la collision a lieu à l'intérieur de l'ellispoide, le point_contact p est sur l'ellipsoide
function [collision, point_contact] = RayonToucheEllispoide(p, u, interne = false)
    %formule de l'ellipsoide
    %((x-4)^2)/9 + ((y-4)^2)/9 + ((z-11)^2)/81 = 1

    %En se basant sur l'équation de l'ellispoide
    % et sur l'équation de la droite passant par le point p de vecteur directeur u
    a = (u(1))^2 + (u(2))^2 + ((u(3))^2)/9;
    b = (2*((u(1)*p(1)) + (u(2)*p(2)))) - (8*(u(1) + u(2))) + ((2/9)*((u(3)*P(3)) - 11*(u(3))));
    c = (328/9) + (p(1)^2) + (p(2)^2) - (8*(p(1) + p(2))) + ((1/9) * (p(3)^2 - 22*p(3)));

    facteurs = roots([a b c]);

    if (isreal(facteurs))
        if (facteurs(1) == facteurs(2))
            point_contact = p + u * facteurs(1);
        else
            P1 = p + u * facteurs(1);
            P2 = p + u * facteurs(2);
            %Choisir le point le plus proche de l'observateur placé en p
            if (norm(p - P1) < norm(p - P2))
                if (interne)
                    point_contact = P2;
                else
                    point_contact = P1;
                end
            else
                if (interne)
                    point_contact = P1;
                else
                    point_contact = P2;
                end
            end
        end

        collision = true;
    else
        collision = false;
        point_contact = [0, 0, 0];
    end
end

%collision: 0 = collision avec ellipsoide
%           1 = collision avec face 1
%           2 = collision avec face 2
%           3 = collision avec face 3
%           4 = collision avec face 4
%           5 = collision avec face 5
%           6 = collision avec face 6
function [collision, point_contact] = RayonCollisionInterne(p, u)
    %Trouver les collisions avec les 6 plans
    %Vérifier que les points de contacts sont bien sur les faces du bloc
    %Garder le point de contact le plus proche pour être sûr de ne pas entrer en contact par l'intérieur

    dist_min = 9999999;
    face_proche = 0;
    point_face = [0, 0, 0];

    for face = 1:6
        [coll, p_plan] = CollisionPlan(face, p, u);
        if (coll && DetecterColSurface(face, p_plan))
            dist = norm(p - p_plan);
            if (dist < dist_min)
                dist_min = dist;
                face_proche = face;
                point_face = p_plan; 
            end
        end
    end

    [coll_ell, point_ell] = RayonToucheEllispoide(p, u, true);

    if (face_proche)
        %Vérification, le point de contact avec l'ellipsoide devrait être plus loin que celui avec une face
        if (dist_min < norm(p - point_ell))
            collision = face_proche;
            point_contact = point_face;
        end
    else
        collision = 0;
        point_contact = point_ell;
    end
    
end

function [collision, point_contact] = CollisionPlan(num_plan, p, u)
    if (num_plan == 1)
        %(1) -> x = 3
        if (u(1) != 0)
            collision = true;
            point_contact = p + u * ((3 - p(1))/u(1));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end
    elseif (num_plan == 2)
        %(2) -> x = 4
        if (u(1) != 0)
            collision = true;
            point_contact = p + u * ((4 - p(1))/u(1));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 3)    
        %(3) -> y = 3
        if (u(2) != 0)
            collision = true;
            point_contact = p + u * ((3 - p(2))/u(2));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 4)
        %(4) -> y = 5
        if (u(2) != 0)
            collision = true;
            point_contact = p + u * ((5 - p(2))/u(2));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 5)
        %(5) -> z = 12
        if (u(3) != 0)
            collision = true;
            point_contact = p + u * ((12 - p(3))/u(3));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 6)    
        %(6) -> z = 17
        if (u(3) != 0)
            collision = true;
            point_contact = p + u * ((17 - p(3))/u(3));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    end

end

function col = DetecterColSurface(num_plan, P)
    % Collision sur une surface 
    % num_plan: 1 -> AEF
    %           2 -> BCD
    %           3 -> ABF
    %           4 -> CDE
    %           5 -> DEF
    %           6 -> ABC

    A = (3, 3, 17);
    B = (4, 3, 17);
    C = (4, 5, 17);
    D = (4, 5, 12);
    E = (3, 5, 12);
    F = (3, 3, 12);
     
    if (num_plan == 1)     col = PointSurFace(P, A, E, F);
    elseif (num_plan == 2) col = PointSurFace(P, B, C, D);
    elseif (num_plan == 3) col = PointSurFace(P, A, B, F);
    elseif (num_plan == 4) col = PointSurFace(P, C, D, E);
    elseif (num_plan == 5) col = PointSurFace(P, D, E, F);
    elseif (num_plan == 6) col = PointSurFace(P, A, B, C);
    end

end

function Entre = PointSurFace(P, P1, P2, P3)
    P4 = P3 + (P1 - P2);
    norme_u = norm(P1 - P3);

    Entre = norm(P1-P) <= norme_u && norm(P2-P) <= norme_u && norm(P3-P) <= norme_u && norm(P4-P) <= norme_u;
end

% Calculer la normal sur l'ellipsoide
function n = CalculerNormale(pcol)
    x = (pcol(1) -  4) / 9;
    y = (pcol(2) -  4) / 9;
    z = (pcol(3) - 11) / 81;
    n = [x, y, z];
end

% Calculer position vue par observateur (7.42)
function rp = CalculerPositionVue(pos_obs, pos_intersect, list_pos)
    u = CalculerVUnit(pos_obs, pos_intersect);
    d = CalculerDistanceTotale(list_pos);
    % rp = ro + du
    rp = pos_obs + d * u;
end

% Calculer le vecteur unitaire de image virtuelle (7.40)
function u = CalculerVUnit(pos_obs, pos_intersect)
    % r1 - r0
    nominateur = pos_intersect - pos_obs;
    % |r1 - r0| 
    denominateur = norm(nominateur);
    u = nominateur/denominateur;
end

% Calculer distance total parcourus (7.41)
function d = CalculerDistanceTotale(list_pos)
    dist = 0;
    n = 0
    for i=2: length(list_pos)
        if n <= 100
            % SUM (|ri - ri-1|)
            dist += norm(list_pos(i), list_pos(i - 1));
            n += 1;
        end
    end
    
    d = dist;
end

%reflexion: bool, si oui ou non il y a eu reflexion totale interne
%nouveau_vdir: vecteur, nouveau vecteur directeur représentant la nouvelle
%              trajectoire du rayon

function [reflexion, nouveau_vdir] = CalculerNouvelleTrajectoire(vdir, pcol, n1, n2)
    %Vérifier si il y a reflexion ou refraction,
    %retourner le nouveau vecteur directeur du rayon

    normale = CalculerNormale(pcol);
    theta1 = AngleEntreVecteurs(vdir, normale);

    angle_critique = abs(asin(n2/n1));

    reflexion = n1 < n2 && (abs(theta1) > angle_critique);
    
    if (reflexion)
        nouveau_vdir = vdir + 2*cos(theta1)*normale;
    else
        theta2 = asin(n1/n2 * sin(theta1));
        nouveau_vdir = (n1/n2)*vdir + (((n1/n2)*cos(theta1)) - abs(cos(theta2)))*normale;
    end
end

%Calcule l'angle entre les vecteurs u1 et u2
function angle = AngleEntreVecteurs(u1, u2)
    angle = acos(dot(u1,u2)/(norm(u1)*norm(u2)));
end

%p: position de l'observateur
%u: vecteur directeur initial du rayon partant de l'observateur
%D: distance totale parcourue par le rayon
%point: point composant l'image virtuelle
function point = DeroulerRayon(p, u, D)
    point = p + (u/norm(u)) * D;
end