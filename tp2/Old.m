classdef Cinematique
    methods(Static = true)
        function posXY = DeltaPosXY(v_i, t, a)
            posXY = v_i * t + (0.5 * a * t^2);
        end
        
        function pos = Gravite(pos_i, v_i, t)
            pos = pos_i + DeltaPos(v_i, t, Constantes.GRAVITE);
        end
        
        function F = ForceFrottement(v)
            F = -0.5*(Constantes.MV_AIR * Constantes.CV * pi * Constantes.BALLE_RAYON^2 * norm(v)) * v;
        end

        function pos = FrottementVisqueux(pos_i, v_i, t)

        end
    
    endmethods
endclassdef