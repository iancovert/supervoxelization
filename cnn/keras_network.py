# Keras imports
import keras
from keras.models import Model
from keras.layers import Input, Reshape, Dense, Activation, Dropout, Flatten, merge
from keras.layers import LSTM, Convolution3D, Convolution2D, MaxPooling3D
from keras.optimizers import SGD, Adadelta, Adagrad, RMSprop, Adam
from keras.layers.advanced_activations import LeakyReLU

# Network parameters
LAYER_WIDTH = 16

def get_model(time_width = 3):
	# TODO make sure these in right order
	# Extra dimension here might be causing numbers to explode
	# Try changing inits to make all weights smaller by an order of magnitude
	# Consider coming up with a toy problem first: easier than our classification problem
	# Perhaps by creating fake data

	# TODO consider possibility that this field of view is either too large or too small
	main_input = Input(shape=(None,None,None, time_width), dtype='float32',name='main_input')

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='glorot_normal',
		activation='linear',
		border_mode='valid', 
		name='layer0')(main_input)

	x = LeakyReLU(alpha = 0.001)(x)

	x = Convolution3D(nb_filter=LAYER_WIDTH,
		kernel_dim1=5,
		kernel_dim2=5,
		kernel_dim3=5,
		init='he_normal',
		# TODO make sure this does nothing. Or specify LeakyRlu here
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

	x = Convolution3D(nb_filter=100,
		kernel_dim1=7,
		kernel_dim2=7,
		kernel_dim3=7,
		init='he_normal', 
		activation='sigmoid',
		border_mode='valid',
		name="dense0")(x)

	x = Convolution3D(nb_filter=1,
		kernel_dim1=1,
		kernel_dim2=1,
		kernel_dim3=1,
		init='he_normal', 
		activation='sigmoid',
		border_mode='valid',
		name="dense1")(x)

	model = Model(input=[main_input],output=x)

	return model

def get_optimizer(optimizer = None, parameter = 0.001):

	if optimizer is None:
		return Adam(lr = 0.0001)
	elif optimizer == 'Adam':
		return Adam(lr = parameter)
	elif optimizer == 'SGD':
		return SGD(lr = parameter)
	elif optimizer == 'ADAGRAD':
		return Adagrad(lr = parameter)
	else:
		raise NameError('invalid optimizer')