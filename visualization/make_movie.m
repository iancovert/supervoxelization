function make_movie(var, name)
	% Normalize
	var = var - min(var(:));
	var = var / max(var(:));

	% Force scaling
	var(1, 1, 1, :) = 1;

	% Write tif stack
	for ii = 1:size(var, 4)
		imwrite(project_tight(var(:,:,:,ii), true), name, 'WriteMode', 'append', 'Compression', 'none');
	end