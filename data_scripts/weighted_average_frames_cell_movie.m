function copy = weighted_average_frames_cell_movie(var)
	% Create copy
	copy = {};

	% Run weighted average frames on each miniature movie
	jj = 1;
	for ii = 1:numel(var)
		weighted = weighted_average_frames(var{ii});
		if (~ isempty(weighted))
			copy{jj} = weighted;
			jj = jj + 1;
		end
	end