classdef Constantes
    properties (Constant)

        %TERRAIN
        TERRAIN_LARGEUR_GAUCHE = 70;
        TERRAIN_LARGEUR_DROITE = 25;
        TERRAIN_LONGUEUR_HAUT = 50 + 60;
        TERRAIN_LONGUEUR_BAS = 50;
        VERT_HAUTEUR = 3.5;
        VERT_DIAMETRE = 30;

        COUPE_RAYON = 0.054;
        VERT_SPHERE_RAYON = 237.25 / 7;

        POSITION_COUPE_X = 92;
        POSITION_COUPE_Y = 53;

        #BALLE SPHERIQUE
        BALLE_MASSE = 0.0459;
        BALLE_RAYON = 0.02135;

        GRAVITE = [0; 0; -9.8]

    endproperties
endclassdef