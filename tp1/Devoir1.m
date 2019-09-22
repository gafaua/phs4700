function [pcm, MI, aa] = Devoir1(pos, mu, va, fi)
    % TEMP
    pcm = CentreMasse.CMTotal(pos, mu);
    MI = MomentInertie.calculerInertieTotal(mu)
    % aa = AA(MI, fi, va);
    aa = [9; 9; 9];    
end