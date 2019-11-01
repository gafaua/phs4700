%
% Devoir 3
% Lancer balle-boite
% 
%
format long
clear;
CoteBloc=6/100;
bloci=zeros(3,3);
ballei=zeros(2,3);
bloci(1,:)=[4 4 1];
ballei(1,:)=[1 1 2];
for Simulation=1:6
%
%  Cas
%
  if Simulation == 1 
    tl=0.545454;
    bloci(2,:)=[ -2 -3  5 ];
    bloci(3,:)=[0 0 0];
    ballei(2,:)=[ 5 2 0.642424];
  elseif Simulation == 2 
    tl=0.545454;
    bloci(2,:)=[ -2 -3  5 ];
    bloci(3,:)=[0 0 15];
    ballei(2,:)=[ 5 2 0.642424];
  elseif Simulation == 3
    tl=0.071429; 
    bloci(2,:)=[ 0 -6  3 ];
    bloci(3,:)=[0 0 0];
    ballei(2,:)=[7 0 0.40834];
  elseif Simulation == 4 
    tl=0.071429;
    bloci(2,:)=[ 0 -6 3 ];
    bloci(3,:)=[0 0 15];
    ballei(2,:)=[ 7 0 0.40834];
  elseif Simulation == 5 
    tl=0.6; 
    bloci(2,:)=[ -2 -3  5 ];
    bloci(3,:)=[-5 -5 0];
    ballei(2,:)=[ 5 2 0.642424];
  elseif Simulation == 6
    tl=0.1;
    bloci(2,:)=[ -2 -3  5 ];
    bloci(3,:)=[0 0 0];
    ballei(2,:)=[ 5 2 0.1];
  end
  fprintf('\nSimulation %1d\n',Simulation);
  [Touche tf blocf ballef ]=Devoir3(bloci,ballei,tl);
  if Touche == 0 
    fprintf('Une collision s''est produite\n');
  else 
    fprintf('La bloc ou balle touche le sol\n');
  end;
  fprintf('t_f (secondes) :  %8.6f \n',tf);
  fprintf('Position CM du bloc (m)           : (%8.6f ,%8.6f, %8.6f) \n',blocf(1,1),blocf(1,2),blocf(1,3));
  fprintf('Position CM de la balle (m)       : (%8.6f ,%8.6f, %8.6f) \n',ballef(1,1),ballef(1,2),ballef(1,3));
  fprintf('Vitesse CM du bloc (m/s)          : (%8.6f ,%8.6f, %8.6f) \n',blocf(2,1),blocf(2,2),blocf(2,3));
  fprintf('Vitesse CM de la balle (m/s)      : (%8.6f ,%8.6f, %8.6f) \n',ballef(2,1),ballef(2,2),ballef(2,3));
  fprintf('Vitesse angulaire du bloc (rad/s) : (%8.6f ,%8.6f, %8.6f) \n',blocf(3,1),blocf(3,2),blocf(3,3));
  pause;
  clearvars Resultat blocf ballef Post 
end;
