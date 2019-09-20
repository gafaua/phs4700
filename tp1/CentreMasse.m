classdef CentreMasse
  properties
  endproperties
  
  methods (Static = true)
    function cm = CMTotal(pos, mu)
      posBras = CentreMasse.cm_bras();
      posMoteurs = CentreMasse.cm_moteurs();
      posSphere = CentreMasse.cm_sphere();
      posColis = CentreMasse.cm_colis();
      
      posX = ((posBras(1) * (Constantes.masse_bras * 4)) + ...
              (posMoteurs(1) * (Constantes.masse_moteur * 4)) + ...
              (posSphere(1) * Constantes.masse_sphere) + ...
              (posColis(1) * Constantes.masse_colis) ...
             ) / ...
            (Constantes.masse_sphere + Constantes.masse_bras * 4 + Constantes.masse_moteur * 4 + Constantes.masse_colis)

      posY = ((posBras(2) * (Constantes.masse_bras * 4)) + ...
              (posMoteurs(2) * (Constantes.masse_moteur * 4)) + ...
              (posSphere(2) * Constantes.masse_sphere) + ...
              (posColis(2) * Constantes.masse_colis) ...
             ) / ...
            (Constantes.masse_sphere + Constantes.masse_bras * 4 + Constantes.masse_moteur * 4 + Constantes.masse_colis)
             
      posZ = ((posBras(3) * (Constantes.masse_bras * 4)) + ...
              (posMoteurs(3) * (Constantes.masse_moteur * 4)) + ...
              (posSphere(3) * Constantes.masse_sphere) + ...
              (posColis(3) * Constantes.masse_colis) ...
             ) / ...
            (Constantes.masse_sphere + Constantes.masse_bras * 4 + Constantes.masse_moteur * 4 + Constantes.masse_colis)
      
      CM_tot = [posX; posY; posZ];
      cm = pos + CentreMasse.apply_rotation(CM_tot, mu);
    endfunction
  
    function cm = cm_bras() 
      posX = 0;
      posY = 0;
      posZ = Constantes.rayon_bras / 2;
      cm = [posX; posY; posZ];
    endfunction
    
    function cm = cm_sphere()
      cm = Constantes.CM_sphere;
    endfunction
    
    function cm = cm_moteurs()
      posX = 0;
      posY = 0;
      posZ = Constantes.hauteur_moteur / 2;
      cm = [posX; posY; posZ];
    endfunction
    
    function cm = cm_colis()
      cm = Constantes.CM_colis;
    endfunction
    
    function newPos = apply_rotation(pos, mu)
      matRot = CentreMasse.get_matrice_rotY(mu);
      newPos = matRot * pos;
    endfunction
    
    function mat = get_matrice_rotY(mu)
      mat = [cos(mu) 0 sin(mu); 0 1 0; -sin(mu) 0 cos(mu)];
    endfunction
  endmethods
endclassdef