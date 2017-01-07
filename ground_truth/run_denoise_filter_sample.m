load('../data/frame_sample.mat');

% Subtract average frame (where average is defined by this sample)
nb = sample;

addpath('../data_scripts');
average = mean(sample, 4);

for ii = 1:size(nb, 4)
	nb(:,:,:,ii) = nb(:,:,:,ii) - average;
end

% Threshold negative voxels
nb(nb(:) < 0) = 0;

% Tuned through trial and error
collab_f_param = 25;

% Tuned through trial and error
frangi_options.BlackWhite = false;
frangi_options.FrangiScaleRatio = 0.5;
frangi_options.FrangiScaleRange = [1 2];
frangi_options.FrangiAlpha = 10;
frangi_options.FrangiBeta = 10;
frangi_options.FrangiC = 100;

% Apply processing
processed = denoise_and_filter(nb, collab_f_param, frangi_options);

save('../data/processed_sample.mat','-v7.3');
