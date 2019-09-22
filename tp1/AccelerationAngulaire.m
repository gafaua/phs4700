classdef AccelerationAngulaire
    methods(Static=true)
        function aa = AA(mi, fi, va)
            % Moment de force total
            mf = AccelerationAngulaire.MomentForce(fi);

            % Moment cinétique
            mc = mi * va;

            % Accélération angulaire
            aa = inv(mi) * (mf + cross(mc, va)); 
        endfunction

        function mf = MomentForce(fi)
            cm = CentreMasse.CM([0;0;0], 0.0);
            [cmMoteur1, cmMoteur2, cmMoteur3, cmMoteur4] = CentreMasse.CMObjet(Constantes.HAUTEUR_MOTEUR / 2, ...
                                                                               Constantes.LONGUEUR_BRAS + Constantes.RAYON_MOTEUR);
            fi = fi * Constantes.FORCE_MOTEUR;
            mf1 = cross(cmMoteur1 - cm, [0; 0; fi(1)]);
            mf2 = cross(cmMoteur2 - cm, [0; 0; fi(2)]);
            mf3 = cross(cmMoteur3 - cm, [0; 0; fi(3)]);
            mf4 = cross(cmMoteur4 - cm, [0; 0; fi(4)]);

            mf = mf1 + mf2 + mf3 + mf4;
        endfunction
    endmethods
endclassdef