function avg = cell_movie_average(var)
	% Get sum of each miniature movie
	sum_array = {};
	total_frames = 0;
	for i = 1:numel(var)
		sum_array{i} = sum(var{i}, 4);
		total_frames = total_frames + size(var{i}, 4);
	end

	% Create container for average
	avg = zeros(size(sum_array{1}));

	% Increment average with each component
	for i = 1:numel(sum_array)
		avg = avg + sum_array{i} * (size(var{i}, 4) / total_frames);
	end
