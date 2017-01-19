function copy = weighted_average_frames(var, weights)

	% Weights for weighted average
	if (nargin < 2)
		weights = bandpassWeights(1, 4.9, 16);
	end

	% Number of weights
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