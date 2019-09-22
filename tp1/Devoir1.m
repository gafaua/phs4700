function [pcm, MI, aa] = Devoir1(pos, mu, va, fi)
    % TEMP
    pcm = CentreMasse.CM(pos, mu);
    % MI = MomentInertie.calculerInertieTotal(mu);
    MI = MomentInertie.MI();
    aa = AccelerationAngulaire.AA(MI, fi, va);
    % aa = [9; 9; 9];    
end