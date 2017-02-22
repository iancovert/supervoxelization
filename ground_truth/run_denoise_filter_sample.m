load('../data/frame_sample_fourier_filtered.mat');

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
processed = denoise_and_filter(weighted, collab_f_param, frangi_options);

save('../data/processed_sample_fourier.mat', 'processed', '-v7.3');
