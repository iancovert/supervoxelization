load('cleaned_movie.mat');

avg = cell_movie_average(var);

% Remove mean
for ii = 1:size(var, 4)
	var(:,:,:, ii) = var(:,:,:, ii) - avg;
end

% Save cleaned movie mean subtracted
save('cleaned_movie_ms.mat','var','-v7.3');