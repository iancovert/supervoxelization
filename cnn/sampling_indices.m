function inds = sampling_indices(fg, kernel_size, time_buffer)
	% Create kernel for dilating image
	[x y z] = ndgrid(-3:3);
	se = strel(sqrt(x.^2 + y.^2 + x.^2) <= 3);

	% Dilate foreground
	dilated = logical(zeros(size(fg)));
	for ii = 1:size(dilated, 4)
		dilated(:,:,:,ii) = imdilate(fg(:,:,:,ii), se);
	end

	% Parameter related to neural network
	k = (kernel_size - 1) / 2;

	% Ones
	all_ones = find(fg);

	% All zeros
	all_zeros = find(~fg);

	% Ones in dilated foreground
	dilated_ones = find(dilated);

	% Find points in the valid region (usable by neural network)
	all_points = 1:prod(size(fg));
	[x y z t] = ind2sub(size(fg), all_points);
	valid_inds = x > k & x <= (size(fg, 1) - k) & y > k & y <= (size(fg, 2) - k) & z > k & z <= (size(fg, 3) - k) & t >= (1 + time_buffer) & t <= (size(fg, 4) - time_buffer);
	valid_points = all_points(valid_inds);

	% Compute indices of ones, close zeros and far zeros
	ones_inds = intersect(all_ones, valid_points);
	close_zeros_inds = intersect(setdiff(dilated_ones, all_ones), valid_points);
	far_zeros_inds = intersect(setdiff(all_zeros, dilated_ones), valid_points);

	% Convert to subindices for Python
	[x_ones, y_ones, z_ones, t_ones] = ind2sub(size(fg), ones_inds);
	[x_close_zeros, y_close_zeros, z_close_zeros, t_close_zeros] = ind2sub(size(fg), close_zeros_inds);
	[x_far_zeros, y_far_zeros, z_far_zeros, t_far_zeros] = ind2sub(size(fg), far_zeros_inds);

	% Subtract 1 for Python
	x_ones = x_ones - 1; y_ones = y_ones - 1; z_ones = z_ones - 1; t_ones = t_ones - 1;
	x_close_zeros = x_close_zeros - 1; y_close_zeros = y_close_zeros - 1; z_close_zeros = z_close_zeros - 1; t_close_zeros = t_close_zeros - 1;
	x_far_zeros = x_far_zeros - 1; y_far_zeros = y_far_zeros - 1; z_far_zeros = z_far_zeros - 1; t_far_zeros = t_far_zeros - 1;

	% Pack up into struct
	clear ones_inds close_zeros_inds far_zeros_inds;
	ones_inds.x = x_ones; ones_inds.y = y_ones; ones_inds.z = z_ones; ones_inds.t = t_ones;
	close_zeros_inds.x = x_close_zeros; close_zeros_inds.y = y_close_zeros; close_zeros_inds.z = z_close_zeros; close_zeros_inds.t = t_close_zeros;
	far_zeros_inds.x = x_far_zeros; far_zeros_inds.y = y_far_zeros; far_zeros_inds.z = z_far_zeros; far_zeros_inds.t = t_far_zeros;
	inds.ones = ones_inds;
	inds.close_zeros = close_zeros_inds;
	inds.far_zeros = far_zeros_inds;
