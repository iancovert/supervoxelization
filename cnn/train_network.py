# Keras imports
import keras
from keras.models import Model
from keras.layers import Input, Reshape, Dense, Activation, Dropout, Flatten, merge
from keras.layers import LSTM, Convolution3D, Convolution2D, MaxPooling3D
from keras.optimizers import SGD, Adadelta, Adagrad, RMSprop, Adam
from keras.layers.advanced_activations import LeakyReLU

# Data imports
from dataset_sampling import Dataset

# Network model
import keras_network as kn

# Other imports
import datetime
import os

# Data locations, variable names
indices_filename = '../data/sampling_inds_fourier.mat'
indices_var_name = 'inds'
raw_filename = '../data/truncated_sample.mat'
raw_var_name = 'var'

# Training parameters
testing = 0.05
NUM_EPOCHS = 10000
NUM_BATCHES_PER_EPOCH = 10000
TEST_EVERY = 500
SAVE_LOSS_EVERY = 100

# Model parameters
kernel_size = 23
time_width = 5

# Output locations
save_directory = None
train_loss_file = 'keras_network_training.txt'
test_loss_file = 'keras_network_testing.txt'

def model_filename(prefix = None):
	if (prefix):
		return save_directory + '/' + prefix + '-{:%Y-%m-%d %H.%M.%S}'.format(datetime.datetime.now())
	return save_directory + '/' + '{:%Y-%m-%d %H.%M.%S}'.format(datetime.datetime.now())

def write_loss(loss, dest):
	if dest == 'train':
		f = open(train_fname, 'a')
	elif dest == 'test':
		f = open(test_fname, 'a')
	else:
		print('Loss must be written to either training or testing')
		raise ValueError
	f.write(str(loss) + '\n')
	f.close()

if __name__ == '__main__':
	print('Determining target directory')
	save_directory = os.environ.get('TARGET')
	if save_directory is None:
		print('Must indicate target directory')
		raise
	else:
		if os.path.isdir(save_directory):
			if len(os.listdir(save_directory)) != 0:
				print('Files exists in target directory')
				raise ValueError
		else:
			print('Creating target directory ', save_directory)
			os.makedirs(save_directory)

	print('Getting model')
	model = kn.get_model(time_width = time_width)

	print('Getting optimizer')
	optimizer_type = os.environ.get('OPTIMIZER')
	optimizer_param = os.environ.get('PARAMETER')
	print('Using optimizer: ' + str(optimizer_type))
	if optimizer_param is None:
		optimizer = kn.get_optimizer(optimizer = optimizer_type)
	else:
		print('Using parameter: ' + str(optimizer_param))
		optimizer = kn.get_optimizer(optimizer = optimizer_type, parameter = float(optimizer_param))
	
	print('Compiling model')
	model.compile(loss='mean_squared_error', optimizer = optimizer)

	print('Getting dataset')
	dataset = Dataset(indices_filename, raw_filename, kernel_size, time_width, 0.05, inds_var_name = indices_var_name, raw_var_name = raw_var_name)

	print('Preparing filenames for saving results')
	train_fname = save_directory + '/' + train_loss_file
	test_fname = save_directory + '/' + test_loss_file

	print('Starting training')
	count = 0

	for e in range(NUM_EPOCHS):
		print('Epoch ', e)

		for b in range(NUM_BATCHES_PER_EPOCH):
			# Get training data
			batch_x, batch_y = dataset.next_single()

			# Train
			loss = model.train_on_batch(batch_x, batch_y)

			# Write loss to file periodically
			if (count % SAVE_LOSS_EVERY == 0):
				write_loss(loss, "train")

			# Test periodically
			if (count % TEST_EVERY == 0):
				# Get testing data
				x_test, y_test = dataset.next(is_testing = True)
				
				# Calculate test loss
				test_loss = model.test_on_batch(x_test, y_test)

				# Write loss to file
				write_loss(test_loss, "test")

			count = count + 1

		# Save model at end of epoch
		fname = model_filename(prefix = 'epoch-' + str(e))
		model.save(fname)
