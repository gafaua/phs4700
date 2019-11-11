% @Params:
% p_cube: position du cube
% p_balle: position balle
% p_coll: position de la collision entre la balle et le cube
% vci: vitesse du cube avant collision
% vbi: vitesse de la balle avant collision
% wc: vitesse angulaire du cube
function [vf_bloc, wf_bloc, vf_balle] = ApresCollision(p_cube, p_balle, p_coll, vci, vbi, wc, R)
    % Equation de reference sur le document du cours
    % 
    % 1) calculer les normals au moment des collisions 
    % 2) calculer alpha                                 (5.72)
    %       a) Calculer G pour bloc et balle            (5.73) et (5.74)
    % 3) calculer vitesse selon le point de collision   (5.66)
    % 4) calculer vitesse vr                            (5.68), (5.69) et (5.70)
    % 5) calculer j                                     (5.71)
    % 6) calculer les vitesse finales                   (5.64) et (5.65)
    % 7) calculer vitesse angulaire finale              (5.63)

    ep = 0.8;

    I_balle = [0.0000112 0        0; ...
               0        0.0000112 0; ...
               0        0        0.0000112];

    I_cube = [0.000348 0        0; ...
              0        0.000348 0; ...
              0        0        0.000348];
    
    I_cube = R * I_cube * R';

    n_collision = CalculerNormalUnitaire(p_coll, p_balle);

    alpha = CalculerAlpha(p_balle, p_cube, p_coll, I_balle, I_cube, n_collision);

    vcci = CalculerVitesseSelonPColl(p_cube, p_coll, vci, wc);

    % vbci = vbi, car la balle a pas de vitesse angulaire
    vrb_moins = CalculerVr(ep, n_collision, vbi, vcci);

    j_balle = CalculerJ(alpha, ep, vrb_moins);

    rbc = p_coll - p_balle;
    rcc = p_coll - p_cube;

    vf_balle = CalculerVitesseFinal(vbi, j_balle, n_collision, I_balle, rbc, 0);
    vf_bloc = CalculerVitesseFinal(vcci, j_balle, n_collision, I_cube, rcc, 1);

    wf_bloc = CalculerVitesseAngulaireFinal(wc, j_balle, n_collision, I_cube, rcc);
end

function alpha = CalculerAlpha(p_balle, p_cube, p_coll, I_balle, I_cube, n_collision)
    G_balle = CalculerG(p_balle, p_coll, n_collision, I_balle);
    G_cube = CalculerG(p_cube, p_coll, n_collision, I_cube);

    m_balle = 0.07;
    m_cube = 0.58;

    % alpha = 1 / (1/ma + 1/mb + Ga + Gb)
    alpha = 1/(1/m_balle + 1/m_cube + G_balle + G_cube);
end

function G = CalculerG(p_object, p_coll, n, I_obj)
    roc = p_coll - p_object;

    roc_n = cross(roc, n);

    rnr = cross(roc_n, roc);

    % G = n [I^-1 (roc x n) x roc]
    G = n * (inv(I_obj) * rnr');
end

function n_collision = CalculerNormalUnitaire(p_coll, p_balle)
    rcb = p_balle - p_coll;
    % La normale pointera toujours vers le centre du cercle
    n_collision = rcb/sqrt(rcb(1)^2 + rcb(2)^2 + rcb(3)^2);
end

function voc = CalculerVitesseSelonPColl(p_obj, p_coll, vi, w)
    poc = p_coll - p_obj;
    % vap = va + (wa x rap)
    voc = vi + cross(w, poc);
end

function vr_moins = CalculerVr(ep, n, v_ref, v_autre)
    % vr_moins = n * (vap - vbp)
    vr_moins = n * (v_ref - v_autre)';
end

function j = CalculerJ(alpha, ep, vr_moins)
    % j = -a * (1 + ep) * vr_moins
    j = -alpha * (1 + ep) * vr_moins;
end

function vf = CalculerVitesseFinal(vi, j_obj, n, I_obj, roc, isCube)
    j = j_obj;
    m = 0.07;

    if (isCube == 1)
        j = -j_obj;
        m = 0.58;
    end;

    % vapf = vapi + j(n/m + I^-1 * (rap x n) x rap)
    % vbpf = vbpi - j(n/m + I^-1 * (rbp x n) x rbp)
    rap_n = cross(cross(roc, n), roc);
    I_rapn = inv(I_obj) * rap_n';
    vf = vi + j * (n/m + I_rapn');
end

function wf = CalculerVitesseAngulaireFinal(wi, j_obj, n, I_obj, roc)
    % wf = wi -jI^-1 * (rbp x n)
    rbp_n = cross(roc, n);
    I_rbpn = inv(I_obj) * rbp_n';
    wf = wi - (j_obj * (I_rbpn))';
end