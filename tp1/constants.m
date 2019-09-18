classdef Constants
  properties (Constant)
    %drone (demi-sphere)
    ms = 1.5;
    Rs = 0.3;
    CMs = [0 0 (3*(Constants.Rs))/8];
    
    %bras - (cylindres) (x4)
    Lb = 0.5;
    Rb = 0.025;
    mb = 0.2;
        
    %moteurs - (cylindres) (x4)
    Hm = 0.1;
    Rm = 0.05;
    mm = 0.4;
    Fmax = 25;
    
    %colis - parallélépipède
    mc = 1.2;
    Lc = 0.7;
    lc = 0.4;
    Hc = 0.25;
    CMc = [0 0.1 -0.125];
  end
end