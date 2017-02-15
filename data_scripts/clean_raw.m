load('../data/data4d.mat');

bad_frame_indices = [1 55 73 102 103 121 177 195 252:253 295:312 418 421:441 617 634 656:676 690 742:762 862 951:975 1030:1050 1143 1190:1210 1238 1370:1392 1423:1425 1497];

var = {};

% Get target size
border = 10
x = size(data4d, 1);
y = size(data4d, 2);
z = size(data4d, 3);
x_target = x - 2 * border;
y_target = y - 2 * border;
z_target = z - 2 * border;

% Note: only want frames where we can get sequences of >= 3 

% No frames to add at the head (t = 1)

% Add frames in the middle (in between bad frames)
for ii = 2:numel(bad_frame_indices)
	t_diff = bad_frame_indices(ii) - bad_frame_indices(ii - 1);
	if (t_diff > 3)
		subsequence_num = numel(var) + 1;
		t = bad_frame_indices(ii - 1);
		var{subsequence_num} = zeros(x_target, y_target, z_target, t_diff - 1);
		for ii = (t + 1):(bad_frame_indices(ii) - 1)
			var{subsequence_num}(:,:,:,ii - t) = data4d((border + 1):(x - border), (border + 1):(y - border), (border + 1):(z - border),ii);
		end
	end
end

% Add frames at the tail (t = 1500)
t_diff = size(data4d, 4) - bad_frame_indices(end);
if (t_diff >= 3)
	subsequence_num = numel(var) + 1;
	t = bad_frame_indices(end);
	var{subsequence_num} = zeros(x_target, y_target, z_target, t_diff);
	for ii = (t + 1):size(data4d, 4)
		var{subsequence_num}(:,:,:,ii - t) = data4d((border + 1):(x - border), (border + 1):(y - border), (border + 1):(z - border),ii);
	end
end

% Save new version of movie
save('../data/cleaned_movie.mat','var','-v7.3');
