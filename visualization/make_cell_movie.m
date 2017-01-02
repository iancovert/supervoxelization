function make_cell_movie(var, name)
	% Find max and min across all miniature movies
	global_min = Inf;
	global_max = - Inf;
	for i = 1:numel(var)
		if (min(var{i}(:)) < global_min)
			global_min = min(var{i}(:));
		end

		if (max(var{i}(:)) > global_max)
			global_max = max(var{i}(:));
		end
	end

	% Normalize across all miniature movies
	for i = 1:numel(var)
		var{i} = var{i} - global_min;
		var{i} = var{i} / (global_max - global_min);

		% Force scaling
		var{i}(1, 1, 1, :) = 1;
	end

	% Frame for separating miniature movies
	separator = ones(size(var{1}, 1), size(var{1}, 2), size(var{1}, 3), 1);

	% For each miniature movie, make movie
	for i = 1:numel(var)
		if (i ~= 1)
			make_movie(separator, name, false);
		end

		make_movie(var{i}, name, false);
	end