function make_movie(var, name, normalize)
	% Check if there's a normalize argument
	if (nargin < 3)
		normalize = true;
	end

	% Normalize
	if (normalize)
		var = var - min(var(:));
		var = var / max(var(:));

		% Force scaling
		var(1, 1, 1, :) = 1;
	end

	% Write tif stack
	for ii = 1:size(var, 4)
		imwrite(project_tight(var(:,:,:,ii), true), name, 'WriteMode', 'append', 'Compression', 'none');
	end