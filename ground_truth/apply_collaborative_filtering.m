function processed = apply_collaborative_filtering(var, collab_f_param)
	processed = var;

	for ii = 1:size(processed, 4)
		processed(:,:,:,ii) = bm4d(processed(:,:,:,ii), 'Gauss', collab_f_param);
	end