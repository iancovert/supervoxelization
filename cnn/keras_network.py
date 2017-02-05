# Keras imports
import keras
from keras.models import Model
from keras.layers import Input, Reshape, Dense, Activation, Dropout, Flatten, merge
from keras.layers import LSTM, Convolution3D, Convolution2D, MaxPooling3D
from keras.optimizers import SGD, Adadelta, Adagrad, RMSprop, Adam
from keras.layers.advanced_activations import LeakyReLU

# Data imports
from dataset_sampling import Dataset

# Other imports
import datetime

# Data locations, variable names
indices_filename = '../data/sampling_indices.mat'
indices_var_name = 'inds'
raw_filename = '../data/frame_sample.mat'
raw_var_name = 'sample'

# Network parameters
LAYER_WIDTH = 16
testing = 0.05
NUM_EPOCHS = 10000
NUM_BATCHES_PER_EPOCH = 1000
TEST_EVERY = 200
SAVE_EVERY_TEST = 200

# Output locations
save_directory = 'trial_one'
train_loss_file = 'keras_network_training.txt'
test_loss_file = 'keras_network_testing.txt'

def model_filename(prefix = None):
  if (prefix):
    return save_directory + '/' + prefix + '-{:%Y-%m-%d %H.%M.%S}'.format(datetime.datetime.now())
  return save_directory + '/' + '{:%Y-%m-%d %H.%M.%S}'.format(datetime.datetime.now())

def get_model():
	main_input = Input(shape=(23,23,23, 3), dtype='float32',name='main_input')

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='he_normal', 
		activation='linear',
		border_mode='valid', 
		name='layer0')(main_input)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='he_normal', 
		activation='linear',
		border_mode='valid',
		name='layer1')(x)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='he_normal', 
		activation='linear',
		border_mode='valid', 
		name='layer2')(x)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='he_normal', 
		activation='linear',
		border_mode='valid', 
		name='layer3')(x)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Flatten(name='main_flatten')(x)

	x = Dense(100, activation="linear", name="dense0")(x)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Dense(1, activation="sigmoid", name="dense1")(x)

	model = Model(input=[main_input],output=x)

	return model

if __name__ == '__main__':
	print('Getting model')
	model = get_model()
	optimizer = Adam(lr=.0001)

	print('Compiling model')
	model.compile(loss='mean_squared_error', optimizer = optimizer)

	print('Getting dataset')
	dataset = Dataset(indices_filename, raw_filename, 23, 0.05, inds_var_name = indices_var_name, raw_var_name = raw_var_name)

	print('Preparing filenames for saving results')
	train_fname = save_directory + '/' + train_loss_file
	test_fname = save_directory + '/' + test_loss_file

	print('Starting training')
	count = 0
	test_count = 0

	best_testing_loss = float('+inf')

	for e in range(NUM_EPOCHS):
		print('Epoch ', e)

		for b in range(NUM_BATCHES_PER_EPOCH):
			# Get training data
			batch_x, batch_y = dataset.next_single()

			# Train
			loss = model.train_on_batch(batch_x, batch_y)

			# Write loss to file
			with open(train_fname,'a') as f:
				f.write(str(loss) + '\n')
				f.close()

			# Test sometimes
			if (count % TEST_EVERY == 0):
				# Get testing data
				x_test, y_test = dataset.next(is_testing = True)
				test_loss = model.test_on_batch(x_test, y_test)

				# Write loss to file
				with open(test_fname,'a') as f:
					f.write(str(test_loss) + '\n')
					f.close()

				# Save model periodically
				if test_count % SAVE_EVERY_TEST == 0:
					fname = model_filename(prefix = 'periodic-' + str(test_count))
					model.save(fname)

				test_count = test_count + 1

			count = count + 1

		# Save model at end of epoch
		fname = model_filename(prefix = 'epoch-' + str(e))
		model.save(fname)
