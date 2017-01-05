function processed = denoise_and_filter(var, collab_f_param, frangi_options)
	% Add paths for collaborative filtering and frangi filtering
	addpath('../collaborative_filtering');
	addpath('../frangi_filtering');

	% Create container for processed frames
	processed = zeros(size(var));

	% Process frames one at a time
	for ii = 1:size(var, 4)
		% Apply collaborative filtering
		temp = bm4d(var(:,:,:,ii), 'Gauss', collab_f_param);

		% Apply frangi filtering
		processed(:,:,:,ii) = FrangiFilter3D(temp, frangi_options);
	end