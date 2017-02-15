import h5py
import numpy as np
import keras_network as kn
from keras.models import load_model

def open_model(filename):
	f = h5py.File(filename, 'r+')
    if 'optimizer_weights' in f:
            del f['optimizer_weights']
    model = load_model(filename)
    f.close()
    return model