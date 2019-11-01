function empty = Plotter(rbt, simulation, option)
    empty = 0;

	p = plot3(rbt(:, 1), rbt(:, 2), rbt(:, 3), "o");
	hold on;
	if option == 3
		legend("Option 1", "Option 2", "Option 3");
		Terrain();
		sim = strcat("Simulation", " ", mat2str(simulation)); 
		title (sim);
	end
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