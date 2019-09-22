classdef CentreMasse
    methods(Static = true)
        % Calcul du CM total du drone.
        function cm = CM(pos, mu)
            sommeMasses = (Constantes.MASSE_DSPHERE + ...
                           Constantes.MASSE_BRAS * 4 + ....
                           Constantes.MASSE_MOTEUR * 4 + ...
                           Constantes.MASSE_COLIS);
            [cmBras1, cmBras2, cmBras3, cmBras4] = CentreMasse.CMObjet(Constantes.RAYON_BRAS, ...
                                                                       Constantes.LONGUEUR_BRAS / 2);
            [cmMoteur1, cmMoteur2, cmMoteur3, cmMoteur4] = CentreMasse.CMObjet(Constantes.HAUTEUR_MOTEUR / 2, ...
                                                                               Constantes.LONGUEUR_BRAS + Constantes.RAYON_MOTEUR);
            sommeCM = Constantes.CM_DSPHERE * Constantes.MASSE_DSPHERE + ...
                      (cmBras1 + cmBras2 + cmBras3 + cmBras4) * Constantes.MASSE_BRAS + ...
                      (cmMoteur1 + cmMoteur2 + cmMoteur3 + cmMoteur4) * Constantes.MASSE_MOTEUR + ...
                      Constantes.CM_COLIS * Constantes.MASSE_COLIS;
            cmPreRotation = sommeCM / sommeMasses;

            % Application de la rotation
            matRot = [cos(mu) 0 sin(mu); 0 1 0; -sin(mu) 0 cos(mu)];
            cm = pos + matRot * cmPreRotation;
        endfunction

        % Calcul du CM des objets situés autour de la sphère.
        function [cmObj1, cmObj2, cmObj3, cmObj4] = CMObjet(hauteur, distanceCentre)
            distance = Constantes.RAYON_DSPHERE + distanceCentre;
            cmObj1 = [distance; 0; hauteur];
            cmObj2 = [0; distance; hauteur];
            cmObj3 = [-distance; 0; hauteur];
            cmObj4 = [0; -distance; hauteur];
        endfunction
    endmethods
endclassdef