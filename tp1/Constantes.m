classdef Constantes
  properties (Constant)
    %drone (demi-sphere)
    MASSE_SPHERE = 1.5;
    RAYON_SPHERE = 0.3;
    CM_SPHERE = [0; 0; (3*(0.3))/8];

    %bras - (cylindres) (x4)
    MASSE_BRAS = 0.2;
    LONGUEUR_BRAS = 0.5;
    RAYON_BRAS = 0.025;
        
    %moteurs - (cylindres) (x4)
    HAUTEUR_MOTEUR = 0.1;
    RAYON_MOTEUR = 0.05;
    MASSE_MOTEUR = 0.4;
    FORCE_MAX = 25;
    DISTANCE_MOTEUR = 0.15 + 0.5 + 0.025;

    %colis - parallélépipède
    CM_COLIS = [0; 0.1; -0.125];
    MASSE_COLIS = 1.2;
    LONGUEUR_COLIS = 0.7;
    LARGEUR_COLIS = 0.4;
    HAUTEUR_COLIS = 0.25;
  endproperties
endclassdef  

