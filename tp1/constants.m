classdef Constants
  properties (Constant)
    %drone (demi-sphere)
    masse_sphere = 1.5;
    rayon_sphere = 0.3;
    CM_sphere = [0 0 (3*(Constants.rayon_sphere))/8];
    
    %bras - (cylindres) (x4)
    masse_bras = 0.2;
    longueur_bras = 0.5;
    rayon_sphere = 0.025;
        
    %moteurs - (cylindres) (x4)
    hauteur_moteur = 0.1;
    rayon_moteur = 0.05;
    masse_moteur = 0.4;
    Fmax = 25;
    
    %colis - parallélépipède
    CM_colis = [0 0.1 -0.125];
    masse_colis = 1.2;
    longueur_colis = 0.7;
    largeur_colis = 0.4;
    hauteur_colis = 0.25;
  end
end