load('../data/frame_sample_weighted.mat');

collab_f_param = 25;
processed = apply_collaborative_filtering(weighted, collab_f_param);

save('../data/frame_sample_denoised.mat', 'processed', '-v7.3');
