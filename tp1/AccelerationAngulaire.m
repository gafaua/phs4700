classdef AccelerationAngulaire
    methods(Static=true)
        function aa = AA(MI, F, VA)
            MF = AccelerationAngulaire.MomentForceMoteurs(F);      %Moment de forces
            MC = MI * VA;                       %Moment cinétique
            aa = inv(MI) * (MF + cross(MC, VA));%Accélération angulaire
        endfunction

        function mf = MomentForceMoteurs(F)
            CM = CentreMasse.CM([0;0;0], 0);
            MF_1 = cross([Constantes.DISTANCE_MOTEUR; 0; 0] - CM, [0; 0; F(1)]);
            MF_2 = cross([0; Constantes.DISTANCE_MOTEUR; 0] - CM, [0; 0; F(2)]);
            MF_3 = cross([-Constantes.DISTANCE_MOTEUR; 0; 0] - CM, [0; 0; F(3)]);
            MF_4 = cross([0; -Constantes.DISTANCE_MOTEUR; 0] - CM, [0; 0; F(4)]);

            mf = MF_1 + MF_2 + MF_3 + MF_4;
        endfunction
    endmethods
endclassdef