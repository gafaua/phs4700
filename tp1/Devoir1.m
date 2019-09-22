function [pcm, MI, aa] = Devoir1(pos, mu, va, fi)
    pcm = CentreMasse.CM(pos, mu);
    MI = MomentInertie.MI();
    aa = AccelerationAngulaire.AA(MI, fi, va);
end