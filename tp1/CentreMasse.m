classdef CentreMasse
    methods(Static = true)
        % Calcul du CM total du drone.
        function cm = CM(pos, mu)
            sommeMasses = (Constantes.MASSE_SPHERE + ...
                           Constantes.MASSE_BRAS * 4 + ....
                           Constantes.MASSE_MOTEUR * 4 + ...
                           Constantes.MASSE_COLIS);
            [cmBras1, cmBras2, cmBras3, cmBras4] = CentreMasse.CMObjet(Constantes.RAYON_BRAS, ...
                                                                       Constantes.RAYON_SPHERE + Constantes.LONGUEUR_BRAS / 2, ...
                                                                       Constantes.MASSE_BRAS);
            [cmMoteur1, cmMoteur2, cmMoteur3, cmMoteur4] = CentreMasse.CMObjet(Constantes.HAUTEUR_MOTEUR / 2, ...
                                                                               Constantes.RAYON_SPHERE + Constantes.LONGUEUR_BRAS + Constantes.RAYON_MOTEUR, ...
                                                                               Constantes.MASSE_MOTEUR);
            sommeCM = Constantes.CM_SPHERE * Constantes.MASSE_SPHERE + ...
                      cmBras1 + cmBras2 + cmBras3 + cmBras4 + ...
                      cmMoteur1 + cmMoteur2 + cmMoteur3 + cmMoteur4 + ...
                      Constantes.CM_COLIS * Constantes.MASSE_COLIS;
            cmPreRotation = sommeCM / sommeMasses;

            % Application de la rotation
            matRot = [cos(mu) 0 sin(mu); 0 1 0; -sin(mu) 0 cos(mu)];
            cm = pos + matRot * cmPreRotation;
        endfunction

        % Calcul du CM des objets situés autour de la sphère.
        function [cmObj1, cmObj2, cmObj3, cmObj4] = CMObjet(hauteur, longueur, masse)
            distance = Constantes.RAYON_SPHERE + longueur;
            cmObj1 = [distance; 0; hauteur] * masse;
            cmObj2 = [0; distance; hauteur] * masse;
            cmObj3 = [-distance; 0; hauteur] * masse;
            cmObj4 = [0; -distance; hauteur] * masse;
        endfunction
    endmethods
endclassdef