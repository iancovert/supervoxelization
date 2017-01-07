function processed = apply_collaborative_filtering(var, collab_f_param)
	% Add path for collaborative filtering source code
	addpath('../collaborative_filtering');

	% Create variable for new frames
	processed = var;

	% Process frames
	for ii = 1:size(processed, 4)
		processed(:,:,:,ii) = bm4d(processed(:,:,:,ii), 'Gauss', collab_f_param);
	end