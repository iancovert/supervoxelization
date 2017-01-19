import numpy as np
import h5py
from indices_tools import indices_subset

def enrich_kernel(kernel):
	return kernel

class Dataset:
	def __init__(self, indices_filename, raw_filename, kernel_size, perc_testing, raw_var_name = 'var', inds_var_name = 'inds'):
		# Load indices of points to sample
		indices_file = h5py.File(indices_filename, 'r')
		
		# Extract sets of indices
		ones = indices_file[inds_var_name]['ones']
		close_zeros = indices_file[inds_var_name]['close_zeros']
		far_zeros = indices_file[inds_var_name]['far_zeros']

		# Count number of ones, close zeros, far zeros
		n_ones = ones['x'].shape[1]
		n_close_zeros = close_zeros['x'].shape[1]
		n_far_zeros = far_zeros['x'].shape[1]

		# Get subsets of indices for training and testing
		ones_subset_testing, ones_subset_training = indices_subset(n_ones, perc_testing)
		close_zeros_subset_testing, close_zeros_subset_training = indices_subset(n_close_zeros, perc_testing)
		far_zeros_subset_testing, far_zeros_subset_training = indices_subset(n_far_zeros, perc_testing)

		# Save subsets in object
		self.training_subsets = {
			'ones': ones_subset_training, 
			'close_zeros': close_zeros_subset_training, 
			'far_zeros': far_zeros_subset_training
		}
		self.testing_subsets = {
			'ones': ones_subset_testing, 
			'close_zeros': close_zeros_subset_testing, 
			'far_zeros': far_zeros_subset_testing
		}

		# Save indices
		self.ones = {
			'x': ones['x'][0, :].astype(int), 
			'y': ones['y'][0, :].astype(int), 
			'z': ones['z'][0, :].astype(int), 
			't': ones['t'][0, :].astype(int)
		}
		self.close_zeros = {
			'x': close_zeros['x'][0, :].astype(int), 
			'y': close_zeros['y'][0, :].astype(int), 
			'z': close_zeros['z'][0, :].astype(int), 
			't': close_zeros['t'][0, :].astype(int)
		}
		self.far_zeros = {
			'x': far_zeros['x'][0, :].astype(int), 
			'y': far_zeros['y'][0, :].astype(int), 
			'z': far_zeros['z'][0, :].astype(int), 
			't': far_zeros['t'][0, :].astype(int)
		}

		# Load movie
		raw_file = h5py.File(raw_filename, 'r')
		self.movie = raw_file[raw_var_name]

		# Kernel size
		self.kernel_size = kernel_size
		self.k = int((kernel_size - 1)/2)

	def next_single(self):
		# Create empty tensors
		batch_x = np.zeros(
			(1, self.kernel_size, self.kernel_size, self.kernel_size, 3),
			dtype = np.float32)
		batch_y = np.zeros(
			(1, 1), 
			dtype = np.float32)

		# Select whether it's a one, close zero or far zero
		typeSelector = int(np.random.random() * 3)
		if (typeSelector == 0):
			# One
			subset = self.training_subsets.ones
			inds = self.ones
			Y = 1
		elif (typeSelector == 1):
			# Close zero
			subset = self.training_subsets.close_zeros
			inds = self.close_zeros
			Y = 0
		else:
			# Far zero
			subset = self.training_subsets.far_zeros
			inds = self.far_zeros
			Y = 0

		# Fetch index of sampled point
		indexSelector = np.random.randint(0, len(subset))
		index = subset[indexSelector]
		x = inds.x[index]
		y = inds.y[index]
		z = inds.z[index]
		t = inds.t[index]
		
		# Fill tensors
		batch_y[0, 0] = Y
		k = self.k
		kernel = self.movie[(t - 1):(t + 1), (z - k):(z + k + 1), (y - k):(y + k + 1), (x - k):(x + k + 1)]
		batch_x[0, :, :, :, :] = enrich_kernel(kernel)

		return batch_x, batch_y

	def next(self, is_testing = False, batch_size = 16):
		# Create empty tensors
		batch_x = np.zeros(
			(batch_size, self.kernel_size, self.kernel_size, self.kernel_size, 3),
			dtype = np.float32)
		batch_y = np.zeros(
			(batch_size, 1), 
			dtype = np.float32)

		# Determine whether subset should be taken from training or testing
		if is_testing:
			subsets = self.testing_subsets
		else:
			subsets = self.training_subsets

		# Fill in tensors
		for i in range(batch_size):
			# Select whether it's a one, close zero or far zero
			typeSelector = int(np.random.random() * 3)
			if (typeSelector == 0):
				# One
				subset = self.training_subsets.ones
				inds = self.ones
				Y = 1
			elif (typeSelector == 1):
				# Close zero
				subset = self.training_subsets.close_zeros
				inds = self.close_zeros
				Y = 0
			else:
				# Far zero
				subset = self.training_subsets.far_zeros
				inds = self.far_zeros
				Y = 0

			# Fetch index of sampled point
			indexSelector = np.random.randint(0, len(subset))
			index = subset[indexSelector]
			x = inds.x[index]
			y = inds.y[index]
			z = inds.z[index]
			t = inds.t[index]
			
			# Fill tensors
			batch_y[i, 0] = Y
			k = self.k
			kernel = self.movie[(t - 1):(t + 1), (z - k):(z + k + 1), (y - k):(y + k + 1), (x - k):(x + k + 1)]
			batch_x[i, :, :, :, :] = enrich_kernel(kernel)

		return batch_x, batch_y
