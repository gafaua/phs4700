%Cinematic

classdef Cinematique
    methods(Static = true)
        function pos = Gravite(pos_i, v_i, t)
            deltaPos = v_i * t + (0.5 * Constantes.GRAVITE * t^2);
            pos = pos_i + deltaPos;
        end
    
    endmethods

endclassdef