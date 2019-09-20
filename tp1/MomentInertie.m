classdef MomentInertie

    properties
    endproperties

    methods (Static = true)

        function momentInertieTotal = calculerInertieTotal(centreMasseTotal)
            [bras1 bras2 bras3 bras4] = centreMasseObjet(Constantes.rayon_bras, Constantes.longueur_bras / 2)
            [moteur1 moteur2 moteur3 moteur4] = centreMasseObjet(Constantes.hauteur_moteur / 2, Constantes.longueur_bras + Constantes.rayon_moteur)
            centreMasseSphere = CentreMasse.cm_sphere()
            centreMasseColis = CentreMasse.cm_colis()

            inertieDemiSphere = calculerMIDemisphere() + Constantes.masse_sphere * calculerEcartInertie(centreMasseSphere)
            inertieColis = calculerMIparralelepipede() + Constantes.centreMasseColis * calculerEcartInertie(centreMasseColis)

            inertieBras1 = calculerMIBras(true) + Constantes.masse_bras * calculerEcartInertie(bras1)
            inertieBras2 = calculerMIBras()     + Constantes.masse_bras * calculerEcartInertie(bras2)
            inertieBras3 = calculerMIBras(true) + Constantes.masse_bras * calculerEcartInertie(bras3)
            inertieBras4 = calculerMIBras()     + Constantes.masse_bras * calculerEcartInertie(bras4)

            inertieMoteur1 = calculerMIMoteur() + Constantes.masse_moteur * calculerEcartInertie(moteur1)
            inertieMoteur2 = calculerMIMoteur() + Constantes.masse_moteur * calculerEcartInertie(moteur2)
            inertieMoteur3 = calculerMIMoteur() + Constantes.masse_moteur * calculerEcartInertie(moteur3)
            inertieMoteur4 = calculerMIMoteur() + Constantes.masse_moteur * calculerEcartInertie(moteur4)

            momentInertieTotal = inertieDemiSphere + inertieColis + inertieBras1 + inertieBras2 + inertieBras3 + inertieBras4 + inertieMoteur1 + inertieMoteur2 + inertieMoteur3 + inertieMoteur4

        endfunction

        function demiSphereMI = calculerMIDemisphere()
            matrix = [83/320 0 0; 0 83/320 0; 0 0 2/5]
            rayonSquared = Constantes.rayon_sphere^2
            demiSphereMI = matrix * Constantes.masse_sphere * rayonSquared
        endfunction

        function brasMI = calculerMIBras(isOnx)
            rayonSquared = Constantes.rayon_bras^2
            longueurSquared = Constantes.longueur_bras^2
            MIx = 0
            MIy = 0
            MIz = 0

            if isOnx == true
                MIx = Constantes.masse_bras * rayonSquared
                MIy = (1/2 * Constantes.masse_bras * rayonSquared) + (1/12 * Constantes.masse_bras * longueurSquared)
                MIz = (1/2 * Constantes.masse_bras * rayonSquared) + (1/12 * Constantes.masse_bras * longueurSquared)
            else
                MIx = 1/2 * Constantes.masse_bras * rayonSquared) + (1/12 * Constantes.masse_bras * longueurSquared)
                MIy = Constantes.masse_bras * rayonSquared
                MIz = (1/2 * Constantes.masse_bras * rayonSquared) + (1/12 * Constantes.masse_bras * longueurSquared)
            end

            brasMI = [MIx  0 0; 0 MIy 0; 0 0 MIz]

        endfunction

        function moteurMI = calculerMIMoteur()
            rayonSquared = Constantes.rayon_moteur^2
            hauteurSquared = Constantes.hauteur_moteur^2

            MIx = (1/4 * Constantes.masse_moteur * rayonSquared) + (1/12 * Constantes.masse_moteur * hauteurSquared)
            MIy = (1/4 * Constantes.masse_moteur * rayonSquared) + (1/12 * Constantes.masse_moteur * hauteurSquared)
            MIz = 1/2 * Constantes.masse_moteur * rayonSquared;

            moteurMI = [MIx 0 0; 0 MIy 0; 0 0 MIz];
        endfunction

        function parralelepipedeMI = calculerMIparralelepipede()
            largeurSquared = Constantes.largeur_colis^2
            longueurSquared = Constantes.longueur_colis^2
            hauteurSquared = Constantes.hauteur_colis^2

            MIx = 1/12 * Constantes.masse_colis * (longueurSquared + hauteurSquared)
            MIy = 1/12 * Constantes.masse_colis * (largeurSquared + hauteurSquared)
            MIz = 1/12 * Constantes.masse_colis * (largeurSquared + longueurSquared)

            parralelepipedeMI = [MIx 0 0; 0 MIy 0; 0 0 MIz]

        endfunction

        function [obj1 obj2 obj3 obj4] = centreMasseObjet(rayon, longueur)
            distance = Constantes.rayon_sphere + longueur;
            obj1 = [distance; 0; rayon]
            obj2 = [0; distance; rayon]
            obj3 = [-distance; 0; rayon]
            obj4 = [0; -distance; rayon]
        endfunction

        function ecartInertie = calculerEcartInertie(vecteur)

            ecartInertie = [vecteur(2)^2 + vecteur(3)^2, -vecteur(1)*vecteur(2), -vecteur(1)*vecteur(3); 
                            -vecteur(2)*vecteur(1), vecteur(1)^2 + vecteur(3)^2, -vecteur(2)*vecteur(3);
                            -vecteur(3)*vecteur(1), -vecteur(3)*vecteur(2), vecteur(1)^2 + vecteur(2)^2];

        endfunction

    endmethods

end