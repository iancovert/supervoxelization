function copy = weighted_average_frames(var)
	% Weights for weighted average
	weights = [0.0015 0.0072 0.0025 0.0072 -0.0359 -0.0580 -0.1482 -0.1612 0.7797 -0.1612 -0.1482 -0.0580 -0.0359 0.0072 0.0025 0.0072 0.0015];
	n_weights = numel(weights);

	% Ensure that frame stack is large enough
	if (size(var, 4) < n_weights)
		copy = [];
		return
	end

	% Create new frame stack
	copy = zeros(size(var, 1), size(var, 2), size(var, 3), size(var, 4) - n_weights + 1);

	% Populate each layer of frame stack
	for ii = ((n_weights - 1) / 2 + 1):(size(var, 4) - (n_weights - 1) / 2)
		for jj = 1:n_weights
			copy(:,:,:,ii - (n_weights - 1) / 2) = copy(:,:,:,ii - (n_weights - 1) / 2) + var(:,:,:,ii + jj - 1 - (n_weights - 1) / 2) .* weights(jj);
		end
	end