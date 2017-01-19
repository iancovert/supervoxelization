function weights = bandpassWeights(lowerCutoff, upperCutoff, number)
	if (nargin < 3)
		number = 16;
	end

	weightsObject = designfilt('bandpassfir','FilterOrder',16,'CutoffFrequency1',lowerCutoff,'CutoffFrequency2',upperCutoff,'SampleRate',10);
	weights = weightsObject.Coefficients;