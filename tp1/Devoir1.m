function [pcm, MI, aa] = Devoir1(pos, mu, va, fi)
    % TEMP
    pcm = CentreMasse.CM(pos, mu);
    MI = MomentInertie.MI();
    % MI = [0 0 0; 0 0 0; 0 0 0];
    % aa = AA(MI, fi, va);
    aa = [9; 9; 9];    
end