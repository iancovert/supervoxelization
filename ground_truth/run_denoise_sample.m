load('../data/frame_sample_nb.mat');

collab_f_param = 25;
processed = apply_collaborative_filtering(nb, collab_f_param);

save('frame_sample_denoised.mat', 'processed', '-v7.3');
