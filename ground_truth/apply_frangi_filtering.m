function processed = frangi_filtering(var, frangi_options)
	% Add path for frangi filtering source code
	addpath('../frangi_filtering');

	% Create variable for new frames
	processed = var;

	% Process frames
	for ii = 1:size(processed, 4)
		processed(:,:,:,ii) = FrangiFilter3D(processed(:,:,:,ii), frangi_options);
	end