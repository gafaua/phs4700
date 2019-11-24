%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roule Devoir 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc ; clear all ; format loose %compact 
format long;
close all ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%% D�finir les cas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cm   = [4,4,11]; %--- centre de masse ellipso�de
rad    = 3; %--- x^2/(rad^2), y^2/(rad^2)
bval   = 9; %--- z^2/(bval^2)
Lame = [3 4; 3 5; 12 17];
nout = [1 1   1   1.2];
nin  = [1  1.5 1.5 1];
dep  = [0 0 5; 0 0 5; 0 0 0; 0 0 5];

for itst=1:4
  tic
  clf;
  hold;
  plot3([dep(itst,1)],[dep(itst,2)],[dep(itst,3)],'ko');
  [x, y, z] = ellipsoid(cm(1),cm(2),cm(3),rad,rad,bval,30);
  surf(x, y, z,'FaceColor','none','EdgeAlpha',0.1)
  Face1x=[Lame(1,1) Lame(1,1) Lame(1,1) Lame(1,1) Lame(1,1)];
  Face2x=[Lame(1,2) Lame(1,2) Lame(1,2) Lame(1,2) Lame(1,2)];
  Face12y=[Lame(2,1) Lame(2,2) Lame(2,2) Lame(2,1) Lame(2,1)];
  Face12z=[Lame(3,1) Lame(3,1) Lame(3,2) Lame(3,2) Lame(3,1)];

  Face34x=[Lame(1,1) Lame(1,2) Lame(1,2) Lame(1,1) Lame(1,1)];  
  Face3y=[Lame(2,1) Lame(2,1) Lame(2,1) Lame(2,1) Lame(2,1)];
  Face4y=[Lame(2,2) Lame(2,2) Lame(2,2) Lame(2,2) Lame(2,2)];
  Face34z=Face12z;

  Face56x=Face34x;
  Face56y=[Lame(2,1) Lame(2,1) Lame(2,2) Lame(2,2) Lame(2,1)];
  Face5z=[Lame(3,1) Lame(3,1) Lame(3,1) Lame(3,1) Lame(3,1)];
  Face6z=[Lame(3,2) Lame(3,2) Lame(3,2) Lame(3,2) Lame(3,2)];

  line(Face1x,Face12y,Face12z,'Color',[0.6 0.6 0.6]);
  line(Face2x,Face12y,Face12z,'Color',[0.6 0.6 0.6]);
  line(Face34x,Face3y,Face34z,'Color',[0.6 0.6 0.6]);
  line(Face34x,Face4y,Face34z,'Color',[0.6 0.6 0.6]);
  line(Face56x,Face56y,Face5z,'Color',[0.6 0.6 0.6]);
  line(Face56x,Face56y,Face6z,'Color',[0.6 0.6 0.6]);
  axis equal
  [xi,yi,zi,face] = Devoir4(nout(itst),nin(itst),dep(itst,:));
  nbpoint=length(face);
  for ipoint=1:nbpoint
    if face(ipoint) == 1
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'r.');
    elseif face(ipoint) == 2
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'c.');
    elseif face(ipoint) == 3
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'g.');
    elseif face(ipoint) == 4
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'y.');
    elseif face(ipoint) == 5
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'b.');
    elseif face(ipoint) == 6
      plot3([xi(ipoint)],[yi(ipoint)],[zi(ipoint)],'m.');
    end
  end
  % hold;
  toc
  fprintf('YES');
  % pause
end