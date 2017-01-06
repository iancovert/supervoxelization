function processed = denoise_and_filter(var, collab_f_param, frangi_options)
	% Process frames
	processed = apply_collaborative_filtering(var, collab_f_param);
	processed = apply_frangi_filtering(processed, frangi_options);