function avg = cell_movie_average(var)
	% Get sum of each miniature movie
	sum_array = {};
	total_frames = 0;
	for ii = 1:numel(var)
		sum_array{ii} = sum(var{ii}, 4);
		total_frames = total_frames + size(var{ii}, 4);
	end

	% Create container for average
	avg = zeros(size(sum_array{1}));

	% Increment average with each component
	for ii = 1:numel(sum_array)
		avg = avg + sum_array{ii} / total_frames;
	end
