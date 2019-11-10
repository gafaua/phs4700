function empty = Plotter(rbt_bloc, rbt_balle, idx)
	clf;
    empty = 0;

	p = plot3(rbt_bloc(:, 1), rbt_bloc(:, 2), rbt_bloc(:, 3), "o");
	hold on;
	d = plot3(rbt_balle(:, 1), rbt_balle(:, 2), rbt_balle(:, 3), "o");

	legend("Bloc", "Balle");
	sim = strcat("Simulation", " ", mat2str(idx)); 
	title (sim);
	hold off;
end