load('cleaned_movie.mat');

avg = cell_movie_average(var);

% Remove mean
for ii = 1:size(var, 4)
	var(:,:,:, ii) = var(:,:,:, ii) - avg;
end

% Zero negative voxels
for ii = 1:numel(var)
	var{ii}(var{ii}(:) < 0) = 0;
end

% Save cleaned movie with mean subtracted
save('cleaned_movie_ms.mat','var','-v7.3');
