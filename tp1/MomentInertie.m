classdef MomentInertie

    properties
    endproperties

    methods (Static = true)

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
            MIz = 1/2 * Constantes.masse_moteur * rayonSquared

            moteurMI = [MIx 0 0; 0 MIy 0; 0 0 MIz]

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

        function distanceCM = vecteurEntreCm(centreMasseTotal, centreMasseObjet)
            distanceX = centreMasseTotal(1) - centreMasseObjet(1)
            distanceY = centreMasseTotal(2) - centreMasseObjet(2)
            distanceZ = centreMasseTotal(3) - centreMasseObjet(3)

            distanceCM = [distanceX distanceY distanceZ]

        endfunction

    endmethods

end