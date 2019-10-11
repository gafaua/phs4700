classdef Constantes
    properties (Constant)

        %TERRAIN
        VERT_HAUTEUR = 3.5;
        VERT_DIAMETRE = 30;

        COUPE_RAYON = 0.054;
        VERT_RAYON = 237.25 / 7;

        #BALLE SPHERIQUE
        BALLE_MASSE = 0.0459;
        BALLE_RAYON = 0.02135;

        %CONDITION INITIALE
        %Coup 1
        POSITION_XY_1 = [10; 10];
        VITESSE_CM_1 = [26.5686; 13.93232; 16.25714];
        VITESSE_ANGULAIRE_1 = [0; -45; 0];

        %Coup 2
        POSITION_XY_2 = [10; 10];
        VITESSE_CM_2 = [26; 16; 18.9935];
        VITESSE_ANGULAIRE_2 = [0; 0; -87.55];

        %Coup 3
        POSITION_XY_3 = [2; 60];
        VITESSE_CM_3 = [25; -5; 21];
        VITESSE_ANGULAIRE_3 = [-30; -30; -60];

    endproperties
endclassdef