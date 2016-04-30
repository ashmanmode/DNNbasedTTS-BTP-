import numpy as np
from six.moves import cPickle
from os import listdir
import scipy.io
from keras.models import Sequential
from keras.layers.core import Dense, Activation, Dropout

def loadData(file):
	f = open(file)
	data = []
	for line in f:
		line = line[:-1]
		nums = line.split(' ')
		data.append(nums)
	return np.array(data)

filesToProcess = 5
inDir = '/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/data/inpFeatsASH/'
outDir = '/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/data/outFeatsASH16/'
f = open('/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/data/inpFeatsASH/files.txt')

X_train = []
Y_train = []
X_test = [];
Y_test = [];
numFilse = 0 
for line in f:
	line = line[:-1]
	fileName = line.split('.')[0]
	inFile = inDir + fileName+'.feat'
	outFile = outDir + fileName+'.ofeat'
	inTemp = loadData(inFile)
	outTemp = scipy.io.loadmat(outFile)['featsAll']
	if(numFilse == 0):
		X_train = inTemp
		Y_train = outTemp
		X_test = inTemp
		Y_test = outTemp
	else:
		X_train = np.concatenate((X_train, inTemp), axis=0)
		Y_train = np.concatenate((Y_train, outTemp), axis=0)
	numFilse = numFilse + 1
	if(numFilse == filesToProcess):
		break

print 'Input Feats', X_train.shape
print 'Output Feats', Y_train.shape

# grapher = Grapher()
model = Sequential()
model.add(Dense(output_dim=256,input_dim=304))
model.add(Activation("relu"))
model.add(Dropout(0.15))

model.add(Dense(output_dim=512,input_dim=256))
model.add(Activation("relu"))
model.add(Dropout(0.15))
model.add(Dense(output_dim=1024,input_dim=512))
model.add(Activation("relu"))
model.add(Dropout(0.15))
model.add(Dense(output_dim=2048,input_dim=1024))
model.add(Activation("relu"))
model.add(Dropout(0.15))

model.add(Dense(output_dim=123,input_dim=2048))

# grapher.plot(nn, 'nn_imdb.png')
model.compile(loss='mean_squared_error', optimizer='rmsprop', metrics=['accuracy'])
model.fit(X_train, Y_train, nb_epoch=2, batch_size=32, validation_split=0.1,  verbose=1)
f = open('training.model', 'wb') 
cPickle.dump(model, f, cPickle.HIGHEST_PROTOCOL)
f.close()

# f = open('training.model', 'rb')
# model = cPickle.load(f)
# f.close()

loss_and_metrics = model.evaluate(X_train, Y_train, batch_size=32)
print loss_and_metrics

Y_out = model.predict(X_test,batch_size=32)
np.savetxt('out.txt',Y_out)
