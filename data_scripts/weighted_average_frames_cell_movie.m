function var = weighted_average_frames_cell_movie(var)
	% Run weighted average frames on each miniature movie
	for ii = 1:numel(var)
		var{ii} = weighted_average_frames(var{ii});
	end