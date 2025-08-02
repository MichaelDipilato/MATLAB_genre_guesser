# MATLAB Genre Guesser

This MATLAB program will try to guess the music genre of some of your favourite songs!
Just choose three different music genres, and then put the corresponding files in the right genre folder. Do not rename these folders: at the beginning of the script MATLAB will ask you to insert the genres.

In every folder there is a "train" subfolder, which is useful in order to train the classifier, and the "test" subfolder, which is used by the classifier to actually guess the music genre.
Speaking of classifiers, I've used two of them: the kNN (k-Nearest Neighbours) and the DT (Decision Tree).
These use two different sets of features, the MFCCs (Mel Frequency Cepstral Coefficients; representation of the short-term power spectrum of a sound) and the Chroma. Chroma-based features, which are also referred to as "pitch class profiles", are a powerful tool for
analyzing music whose pitches can be meaningfully categorized (often into twelve categories) and whose tuning approximates to the equal-tempered scale. 
One main property of chroma features is that they capture harmonic and melodic characteristics of music.

The Project.m file is the main one in which all of the other script are executed. There is also a code subfolder that contains a set of useful functions for feature extraction.
I also added noise to music files (Add_noise.m script) in order to test the classifiers performance whith noisy files and to check how much noise impacts on their ability to guess.

A confusion matrix will be plotted for every classifier using each of the feature sets. This matrix show how accurate the prediction was for every genre. It also allows to compare classifier performance by using
either regular files or noisy files.
