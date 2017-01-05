function denoise_filter_merge(var, collab_f_param, frangi_options, segments, ind, lock_name_base, output)
	% Calculate indices of frames in this batch
	total = 0;
	for ii = 1:numel(var)
		total = total + size(var{ii}, 4);
	end
	start_ind = floor((ind - 1) * total / segments) + 1;
	finish_ind = floor(ind * total / segments);

	% Create vectors to hold cell indices and indices (within miniature movies of each frame)
	cell_indices = [];
	indices = [];
	for ii = 1:numel(var)
		cell_indices = [cell_indices repmat(ii, 1, size(var{ii}, 4))]
		indices = [indices 1:size(var{ii}, 4)];
	end

	% Create single container for frames in this batch
	frames = zeros(size(var{1}, 1), size(var{1}, 1), size(var{1}, 1), finish_ind - start_ind + 1);

	% Put frames into the container
	for ii = start_ind:finish_ind
		cell_index = cell_indices(ii);
		index = indices(ii);
		frames(:,:,:,ii - start_ind + 1) = var{cell_index}(:,:,:,index);
	end

	% Process the frames
	processed = denoise_and_filter(frames, collab_f_param, frangi_options);

	% Figure out lock name (when locked and when unlocked)
	locked_name = [lock_name_base '_locked.txt'];
	unlocked_name = [lock_name_base '_unlocked.txt'];

	% Grab lock
	locked = true;
	while (locked)
		try
			movefile(unlocked_name, locked_name);
			locked = false;
		catch
			pause(10);
		end
	end

	% Load file if it exists
	if (exist(output, 'file'))
		load(output);
	end

	% Write frames into cell array containing all frames
	for ii = start_ind:finish_ind
		stack{ii} = processed(:,:,:,ii - start_ind + 1);
	end

	% Check if cell array is ready to be merged
	if (numel(stack) ~= total)
		ready_to_merge = false;
	else
		ready_to_merge = true;
		for ii = 1:total
			if (isempty(stack{ii}))
				ready_to_merge = false;
			end
		end
	end

	% Merge if ready
	if (ready_to_merge)
		% Put each frame in the appropriate position
		for ii = 1:total
			cell_index = cell_indices(ii);
			index = indices(ii);
			var{cell_index}(:,:,:,index) = stack{ii};
		end

		% Save var, overwriting stack
		save(output, 'var', '-v7.3');
	else
		% Save stack, overwriting old stack
		save(output, 'stack', '-v7.3');
	end

	% Release lock
	movefile(locked_name, unlocked_name);