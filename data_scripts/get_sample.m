load('../data/cleaned_movie.mat');

sample = get_frame_sample(var, 100, 'tail');

average = cell_movie_average(var);
no_background = sample;
for ii = 1:size(no_background, 4)
	no_background(:,:,:,ii) = no_background(:,:,:,ii) - average;
end

save('../data/frame_sample.mat', 'sample', 'no_background', '-v7.3');