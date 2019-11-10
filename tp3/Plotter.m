function empty = Plotter(rbt_bloc, rbt_balle)
	hold off;
    empty = 0;

	p = plot3(rbt_bloc(:, 1), rbt_bloc(:, 2), rbt_bloc(:, 3), "o");
	hold on;
	d = plot3(rbt_balle(:, 1), rbt_balle(:, 2), rbt_balle(:, 3), "o");
	legend("Bloc", "Balle");
	hold on;
	[x, y, z] = sphere();
	surf(0.02*x + rbt_balle(length(rbt_balle), 1), 0.02*y + rbt_balle(length(rbt_balle), 2), 0.02*z + rbt_balle(length(rbt_balle), 3));
	%drawCube([rbt_bloc(length(rbt_bloc), :), 0.06])
	plotcube([0.06 0.06 0.06], rbt_bloc(length(rbt_bloc), :), 1,[1 0 0]);
	% Terrain();

	% sim = strcat("Simulation", " ", mat2str(simulation)); 
	% title (sim);
end

function empty = Terrain()
	empty = 0;

	% First rectangle
	h = patch([0, 0, 60, 60], [0, 70, 70, 0], [0, 0, 0, 0], 'green');
	set(h,'EdgeColor','none');
	hold on;

	% Second rectangle
	h = patch([60, 60, 110, 110], [45, 70, 70, 45], [0, 0, 0, 0], 'green');
	set(h,'EdgeColor','none');
	hold on;

	% Triangle
	h = patch([60, 60, 110], [0, 45, 45], [0, 0, 0], 'green');
	set(h,'EdgeColor','none');
	hold on;

    [x, y, z] = sphere(40);
    rad = 33.89;
    x = rad.*x;
    y = rad.*y;
    z = rad.*z;

    ab = z < 30.39; % R - H
    x(ab) = NaN;
    y(ab) = NaN;
    z(ab) = NaN;

    pX = 92;
    pY = 53;
    pZ = -30.39;

    ps = surf(x + pX, y + pY, z + pZ);
    set(ps, "facecolor", "flat");
    axis equal;

	% Coupe
	t = linspace(0,2*pi,1000)'; 
	circsx = 0.54.*cos(t) + 92; 
	circsy = 0.54.*sin(t) + 53; 
	circsz = ones(1, 1000) * 3.5;
	h = patch(circsx,circsy, circsz, 'k'); 
	hold on;

end

function plotcube(varargin)
% PLOTCUBE - Display a 3D-cube in the current axes
%
%   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES : 3-elements vector that defines the length of cube edges
%   * ORIGIN: 3-elements vector that defines the start point of the cube
%   * ALPHA : scalar that defines the transparency of the cube faces (from 0
%             to 1)
%   * COLOR : 3-elements vector that defines the faces color of the cube
%
% Example:
%   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0]);
%   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0]);
%   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]);
% Default input arguments
inArgs = { ...
  [10 56 100] , ... % Default edge sizes (x,y and z)
  [10 10  10] , ... % Default coordinates of the origin point of the cube
  .7          , ... % Default alpha value for the cube's faces
  [1 0 0]       ... % Default Color for the cube
  };
% Replace default input arguments by input values
inArgs(1:nargin) = varargin;
% Create all variables
[edges,origin,alpha,clr] = deal(inArgs{:});
XYZ = { ...
  [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
  [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
  [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
  [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
  [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
  [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
  };
XYZ = mat2cell(...
  cellfun( @(x,y,z) x*y+z , ...
    XYZ , ...
    repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...
    repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
    'UniformOutput',false), ...
  6,[1 1 1]);
cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
  repmat({clr},6,1),...
  repmat({'FaceAlpha'},6,1),...
  repmat({alpha},6,1)...
  );
view(3);
end