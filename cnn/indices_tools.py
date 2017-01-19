import numpy as np

def bucket_sort(my_array):
	# Find max
	m = np.amax(my_array)
	# Create container for counts (which will be either 0 or 1)
	counts = np.zeros(m + 1, dtype = int)
	for i in my_array:
		counts[i] = 1
	# Dump values back into my_array
	index = 0
	for i in range(m + 1):
		count = counts[i]
		if count == 1:
			my_array[index] = i
			index += 1

def set_diff(largestNum, small):
	occupied = np.ones(largestNum, dtype = int)
	for i in small:
		occupied[i] = 0
	result = np.zeros(np.sum(occupied), dtype = int)
	index = 0
	for i in range(len(occupied)):
		if occupied[i] == 1:
			result[index] = i
			index += 1
	return result

def indices_subset(number, perc_testing):
	n_testing = int(number * perc_testing)
	testing_subset = np.random.choice(number, n_testing, replace = False)
	bucket_sort(testing_subset)
	training_subset = set_diff(number, testing_subset)
	return testing_subset, training_subset