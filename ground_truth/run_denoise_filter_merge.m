% ind must be set when script is run
if (~ exist('ind') || ~ exist('segments'))
	disp('ind and segments must be defined');
	exit
end

load('cleaned_movie.mat');

% Tuned through trial and error
collab_f_param = 25;

% Tuned through trial and error
frangi_options.BlackWhite = false;
frangi_options.FrangiScaleRatio = 0.5;
frangi_options.FrangiScaleRange = [1 2];
frangi_options.FrangiAlpha = 10;
frangi_options.FrangiBeta = 10;
frangi_options.FrangiC = 100;

% Lock's base name
lock_name_base = '../locks/merge_lock';

% Output name
output = '../data/processed_movie.mat';

% Run denoise_filter_merge
denoise_filter_merge(var, collab_f_param, frangi_options, segments, ind, lock_name_base, output);