classdef MomentInertie
    methods(Static = true)
        % Calcul du moment d'inertie du système.
        function mi = MI()
            % Obtention du PCM avant translation et rotation
            pcm = CentreMasse.CM(0, 0);
            
            [miBras1, miBras2, miBras3, miBras4] = MomentInertie.MIBras(pcm);
            [miMoteur1, miMoteur2, miMoteur3, miMoteur4] = MomentInertie.MIMoteur(pcm);

            mi = MomentInertie.MIDemiSphere(pcm) + ...
                 miBras1 + miBras2 + miBras3 + miBras4 + ...
                 miMoteur1 + miMoteur2 + miMoteur3 + miMoteur4 + ...
                 MomentInertie.MIColis(pcm);
        endfunction

        % Moment d'inertie de la demi sphere.
        function miDSphere = MIDemiSphere(pcm)
            matInertie = diag([83/320, 83/320, 2/5]);

            % Moment d'inertie dsphere local
            miDSphereLocal = matInertie * ...
                             Constantes.MASSE_DSPHERE * ...
                             Constantes.RAYON_DSPHERE ^ 2;

            % Moment d'inertie dsphere global
            miDSphere  = miDSphereLocal + ... 
                         Constantes.MASSE_DSPHERE * MomentInertie.CalculerTDC(Constantes.CM_DSPHERE - pcm);
        endfunction

        % Moment d'inertie des bras du drone
        function [miBras1, miBras2, miBras3, miBras4] = MIBras(pcm)
            axePrincipale = Constantes.RAYON_BRAS ^ 2;
            axeSecondaire = (Constantes.RAYON_BRAS ^ 2) / 2 + (Constantes.LONGUEUR_BRAS ^ 2) / 12;
            miBrasXLocal = diag([axePrincipale, axeSecondaire, axeSecondaire]) * Constantes.MASSE_BRAS;
            miBrasYLocal = diag([axeSecondaire, axePrincipale, axeSecondaire]) * Constantes.MASSE_BRAS;

            [cmBras1, cmBras2, cmBras3, cmBras4] = CentreMasse.CMObjet(Constantes.RAYON_BRAS, ...
                                                                       Constantes.RAYON_DSPHERE + Constantes.LONGUEUR_BRAS / 2);
            miBras1 = miBrasXLocal + Constantes.MASSE_BRAS * MomentInertie.CalculerTDC(cmBras1 - pcm);
            miBras2 = miBrasYLocal + Constantes.MASSE_BRAS * MomentInertie.CalculerTDC(cmBras2 - pcm);
            miBras3 = miBrasXLocal + Constantes.MASSE_BRAS * MomentInertie.CalculerTDC(cmBras3 - pcm);
            miBras4 = miBrasYLocal + Constantes.MASSE_BRAS * MomentInertie.CalculerTDC(cmBras4 - pcm);
        endfunction

        % Moment d'inertie des moteurs.
        function [miMoteur1, miMoteur2, miMoteur3, miMoteur4] = MIMoteur(pcm)
            axePrincipale = (Constantes.RAYON_MOTEUR ^ 2) / 2;
            axeSecondaire = (Constantes.RAYON_MOTEUR ^ 2) / 4 + (Constantes.HAUTEUR_MOTEUR ^ 2) / 12;
            miMoteurLocal = diag([axeSecondaire, axeSecondaire, axePrincipale]) * Constantes.MASSE_MOTEUR;

            [cmMoteur1, cmMoteur2, cmMoteur3, cmMoteur4] = CentreMasse.CMObjet(Constantes.HAUTEUR_MOTEUR / 2, ...
                                                                               Constantes.RAYON_DSPHERE + Constantes.LONGUEUR_BRAS + Constantes.RAYON_MOTEUR);
            miMoteur1 = miMoteurLocal + Constantes.MASSE_MOTEUR * MomentInertie.CalculerTDC(cmMoteur1 - pcm);
            miMoteur2 = miMoteurLocal + Constantes.MASSE_MOTEUR * MomentInertie.CalculerTDC(cmMoteur2 - pcm);
            miMoteur3 = miMoteurLocal + Constantes.MASSE_MOTEUR * MomentInertie.CalculerTDC(cmMoteur3 - pcm);
            miMoteur4 = miMoteurLocal + Constantes.MASSE_MOTEUR * MomentInertie.CalculerTDC(cmMoteur4 - pcm);
        endfunction

        % Moment d'inertie du colis.
        function miColis = MIColis(pcm)
            longueurCarree = Constantes.LONGUEUR_COLIS ^ 2;
            largeurCarree = Constantes.LARGEUR_COLIS ^ 2;
            hauteurCarree = Constantes.HAUTEUR_COLIS ^ 2;
            matInertie = diag([largeurCarree + hauteurCarree, ...
                               longueurCarree + hauteurCarree, ...
                               longueurCarree + largeurCarree]);

            % Moment d'inertie olis local
            miColisLocal = matInertie * Constantes.MASSE_COLIS / 12;

            % Moment d'inertie colis global
            miColis = miColisLocal + ...
                      Constantes.MASSE_COLIS * MomentInertie.CalculerTDC(Constantes.CM_COLIS - pcm);
        endfunction

        % Calcul de la matrice selon le DC obtenu à partir de rc.
        % Notes de cours chapitre 2 page 72.
        function matDC = CalculerTDC(dc)
            matDC = [dc(2) ^ 2 + dc(3) ^ 2, -dc(1) * dc(2), -dc(1) * dc(3); ...
                     -dc(2) * dc(1), dc(1) ^ 2 + dc(3) ^ 2, -dc(2) * dc(3); ...
                     -dc(3) * dc(1), -dc(3) * dc(2), dc(1) ^ 2 + dc(2) ^ 2];
        endfunction
    endmethods
endclassdef