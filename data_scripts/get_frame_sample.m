function frames = get_frame_sample(var, n, method, inds)
	% Create vectors to hold cell indices and indices (within miniature movies of each frame)
	cell_indices = [];
	indices = [];
	total = 0;
	for ii = 1:numel(var)
		cell_indices = [cell_indices repmat(ii, 1, size(var{ii}, 4))];
		indices = [indices 1:size(var{ii}, 4)];
		total = total + size(var{ii}, 4);
	end

	% Create container for frames
	frames = zeros(size(var{1}, 1), size(var{1}, 2), size(var{1}, 3), n);

	% Determine frame indices depending on method
	if (strcmp(method, 'head') == 0)
		inds = 1:n;
	elseif (strcmp(method, 'tail') == 0)
		inds = (total - n + 1):total;
	elseif (strcmp(method, 'rand') == 0)
		inds = randperm(total, n);
	elseif (strcmp(method, 'inds') == 0)
		inds = inds;
	else
		return;
	end

	% Put frames into container
	for ii = 1:n
		cell_index = cell_indices(inds(ii));
		index = indices(inds(ii));
		frames(:,:,:,ii) = var{cell_index}(:,:,:,index);
	end