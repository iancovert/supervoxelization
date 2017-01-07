function copy = weighted_average_frames(var)
	% Weights for weighted average
	weights = [0.2 0.6 0.2];

	% Create copy of frame stack
	copy = var;

	% Replace each frame with a weighted average
	copy(:,:,:,1) = (var(:,:,:, 1) * weights(2) + var(:,:,:, 2) * weights(3)) / (weights(2) + weights(3));

	for ii = 2:(size(copy, 4) - 1)
		copy(:,:,:, ii) = var(:,:,:, ii - 1) * weights(1) + var(:,:,:, ii) * weights(2) + var(:,:,:, ii + 1) * weights(3);
	end

	copy(:,:,:, size(var, 4)) = (var(:,:,:, size(var, 4) - 1) * weights(1) + var(:,:,:, size(var, 4)) * weights(2)) / (weights(1) + weights(2));