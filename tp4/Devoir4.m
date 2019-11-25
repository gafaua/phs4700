function [xi,yi,zi,face] = Devoir4(nout, nin, dep)
    points = ScannerZ(nout, nin, dep);

    xi = points(:, 1);
    yi = points(:, 2);
    zi = points(:, 3);
    face = points(:, 4);
end

% Scan les rayons en longeant l'axe des Z.
function points = ScannerZ(nout, nin, dep)
    z = 11; % On commence au point milieu (CM de l'ellipsoid).
    dz = 0.01; % delta z.

    % Les points de contacts, déroulés. Format: [xi yi zi face;].
    points = [];

    % On scan d'abord les z positifs.
    [collision, ~] = RayonToucheEllispoide(dep, [4, 4, z] - dep);
    while (collision)
        pts = ScannerPlanXY(nout, nin, dep, z);
        points = [points; pts];
        z = z + dz;
        [collision, ~] = RayonToucheEllispoide(dep, [4, 4, z] - dep);
    end

    z = 11 - dz; % Retour au point milieu - dz car déjà évalué à 11.

    % On scan ensuite les z négatifs.
    [collision, ~] = RayonToucheEllispoide(dep, [4, 4, z] - dep);
    while (collision)
        pts = ScannerPlanXY(nout, nin, dep, z);
        points = [points; pts];
        z = z - dz;
        [collision, ~] = RayonToucheEllispoide(dep, [4, 4, z] - dep);
    end
end

% On scan un plan XY correspondant à un Z donné.
function points = ScannerPlanXY(nout, nin, dep, z)
    % On commence avec le point milieu.
    x_initial = 4; 
    y_initial = 4;

    % Delta directeur.
    ds = 0.01;

    % Les points de contacts, déroulés. Format: [xi yi zi face;]
    points = [];

    % Vecteur directeur
    pdir = [x_initial, y_initial, z];

    % On récupère le premier point de collision.
    [collision, point_col] = RayonToucheEllispoide(dep, pdir - dep);

    % On scan en se déplaçant vers les y négatifs tant que l'on touche l'ellipse.
    while (collision)        
        [reflexion, nouveau_vdir] = CalculerNouvelleTrajectoire(point_col - dep, point_col, nout, nin);
        if (~reflexion) % Le rayon lumineux rentre dans l'ellipsoide
            [coll_bloc, coord] = TrajectoireDansEllispsoide(dep, point_col, nouveau_vdir, nin, nout);

            if (coll_bloc)
                points = [points; coord];
            end
        end

        % Etape finale pour passer à next while step: Décrementer y.
        pdir = [x_initial, pdir(2) - ds, z];
        [collision, point_col] = RayonToucheEllispoide(dep, pdir - dep);
    end

    % On retourne au centre de l'ellipsoid - ds en x car deja évalué à x_initial.
    pdir = [x_initial - ds, y_initial, z];

    [collision, point_col] = RayonToucheEllispoide(dep, pdir - dep);

    % On scan en se déplaçant vers les x négatifs tant que l'on touche l'ellipse.
    while (collision)
        [reflexion, nouveau_vdir] = CalculerNouvelleTrajectoire(point_col - dep, point_col, nout, nin);
        if (~reflexion) %Le rayon lumineux rentre dans l'ellipsoide
            [coll_bloc, coord] = TrajectoireDansEllispsoide(dep, point_col, nouveau_vdir, nin, nout);

            if (coll_bloc)
                points = [points; coord];
            end
        end

        % Etape finale pour passer à next while step: Décrementer x.
        pdir = [pdir(1) - ds, y_initial, z];
        [collision, point_col] = RayonToucheEllispoide(dep, pdir - dep);
    end
end 

function [coll_bloc, coord] = TrajectoireDansEllispsoide(depart, point, vecteur_directeur, nin, nout)
    point1 = point;
    vdir = vecteur_directeur;

    distance_totale = norm(point - depart);    %On commence à mesurer la distance totale parcourue par le rayon
    
    for n=1:100
        [coll, point2] = RayonCollisionInterne(point1, vdir);

        distance_totale = distance_totale + norm(point2 - point1);

        if (coll)   %collision avec le bloc, ajoute le nouveau point et on arrête
            coll_bloc = true;
            nouveau_point = DeroulerRayon(depart, point - depart, distance_totale);
            coord = [nouveau_point(1), nouveau_point(2), nouveau_point(3), coll];
            
            return;
        else        %collision avec l'ellipsoide, on arrête si le rayon sort de l'ellispoide
            [reflexion, vdir] = CalculerNouvelleTrajectoire(point2 - point1, point2, nin, nout);
            
            if (~reflexion)
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
function [collision, point_contact] = RayonToucheEllispoide(p, u, interne)
    if (nargin == 2)
        interne = false;
    end
    %formule de l'ellipsoide
    %((x-4)^2)/9 + ((y-4)^2)/9 + ((z-11)^2)/81 = 1

    %En se basant sur l'équation de l'ellispoide
    % et sur l'équation de la droite passant par le point p de vecteur directeur u
    a = (u(1))^2 + (u(2))^2 + ((u(3))^2)/9;
    b = (2*((u(1)*p(1)) + (u(2)*p(2)))) - (8*(u(1) + u(2))) + ((2/9)*((u(3)*p(3)) - 11*(u(3))));
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

    if (face_proche && dist_min < norm(p - point_ell))
        %Vérification, le point de contact avec l'ellipsoide devrait être plus loin que celui avec une face
        collision = face_proche;
        point_contact = point_face;
    else
        collision = 0;
        point_contact = point_ell;
    end
end

function [collision, point_contact] = CollisionPlan(num_plan, p, u)
    if (num_plan == 1)
        %(1) -> x = 3
        if (u(1) ~= 0)
            collision = true;
            point_contact = p + u * ((3 - p(1))/u(1));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end
    elseif (num_plan == 2)
        %(2) -> x = 4
        if (u(1) ~= 0)
            collision = true;
            point_contact = p + u * ((4 - p(1))/u(1));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 3)    
        %(3) -> y = 3
        if (u(2) ~= 0)
            collision = true;
            point_contact = p + u * ((3 - p(2))/u(2));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 4)
        %(4) -> y = 5
        if (u(2) ~= 0)
            collision = true;
            point_contact = p + u * ((5 - p(2))/u(2));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 5)
        %(5) -> z = 12
        if (u(3) ~= 0)
            collision = true;
            point_contact = p + u * ((12 - p(3))/u(3));
        else
            collision = false;
            point_contact = [0, 0, 0];
        end

    elseif (num_plan == 6)    
        %(6) -> z = 17
        if (u(3) ~= 0)
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
    % num_plan: 1 -> AFE
    %           2 -> BCD
    %           3 -> BAF
    %           4 -> CDE
    %           5 -> DEF
    %           6 -> ABC

    A = [3, 3, 17];
    B = [4, 3, 17];
    C = [4, 5, 17];
    D = [4, 5, 12];
    E = [3, 5, 12];
    F = [3, 3, 12];
     
    if (num_plan == 1)     col = CollisionPlanYZ(P)
    elseif (num_plan == 2) col = CollisionPlanYZ(P)
    elseif (num_plan == 3) col = CollisionPlanXZ(P)
    elseif (num_plan == 4) col = CollisionPlanXZ(P)
    elseif (num_plan == 5) col = CollisionPlanXY(P)
    elseif (num_plan == 6) col = CollisionPlanXY(P)
    end
end

function collision = CollisionPlanXY(p)
    collision = p(1) >= 3 && p(1) <= 4 && p(2) >= 3 && p(2) <= 5;
end

function collision = CollisionPlanXZ(p)
    collision = p(1) >= 3 && p(1) <= 4 && p(3) >= 12 && p(3) <= 17;
end

function collision = CollisionPlanYZ(p)
    collision = p(2) >= 3 && p(2) <= 5 && p(3) >= 12 && p(3) <= 17;
end

% Calculer la normal sur l'ellipsoide
function n = CalculerNormale(pcol)
    x = (pcol(1) -  4) / 9;
    y = (pcol(2) -  4) / 9;
    z = (pcol(3) - 11) / 81;
    n = [x, y, z];
end

%reflexion: bool, si oui ou non il y a eu reflexion totale interne
%nouveau_vdir: vecteur, nouveau vecteur directeur représentant la nouvelle
%              trajectoire du rayon

function [reflexion, nouveau_vdir] = CalculerNouvelleTrajectoire(vdir, pcol, n1, n2)
    %Vérifier si il y a reflexion ou refraction,
    %retourner le nouveau vecteur directeur du rayon

    n = CalculerNormale(pcol);
    % vecteurs i et k venant du document de référence, utiles pour les calculs suivants
    vec_i = n/norm(n);
    j_ = cross(vdir, vec_i);
    vec_k = cross(vec_i, j_/norm(j_));

    theta1 = AngleEntreVecteurs(vdir, n);
    theta2 = asind(n1/n2 * sind(theta1));
    
    reflexion = abs(sind(theta2)) > 1;
    
    if (reflexion)
        nouveau_vdir = cosd(theta1)*vec_i + sind(theta1)*vec_k;
    else
        nouveau_vdir = -cosd(theta2)*vec_i + sind(theta2)*vec_k;
    end
end

%Calcule l'angle entre les vecteurs u1 et u2
function angle = AngleEntreVecteurs(u1, u2)
    angle = acosd(dot(u1,u2)/(norm(u1)*norm(u2)));
end

%p: position de l'observateur
%u: vecteur directeur initial du rayon partant de l'observateur
%D: distance totale parcourue par le rayon
%point: point composant l'image virtuelle
function point = DeroulerRayon(p, u, D)
    point = p + (u/norm(u) * D);
end