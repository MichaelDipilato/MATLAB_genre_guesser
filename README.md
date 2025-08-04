# MATLAB Genre Guesser

This MATLAB program attempts to guess the music genre of some of your favourite songs using machine learning techniques. It was developed as a project as part of the course of Sound and Music Computing at the University of Milan

## Overview
In this project, I've used two classifiers:
 - kNN (k-Nearest Neighbours): compares a sample with the k most similar samples in the training set
 - DT (Decision Tree): builds a tree-like model of decision

Each classifier uses two different feature sets:
- MFCCs (Mel Frequency Cepstral Coefficients): representation of the short-term power spectrum of a sound
- Chroma-based features: capture harmonic and melodic characteristics of music by mapping audio into twelve pitch classes, used for tonal music analysis

## How it works
- Choose three different music genres;
- Place your audio files into the data folder, which contains three subfolders. Do not rename them, the script will prompt you to enter the genre names at runtime

Each genre folder contains:
- train/, audio files useful for training the classifiers;
- test/, audio files used by the classifier to guess the genre.

In order to get good results, it is recommended to use at least three different files in the train folder. These are empty, therefore I had to store some .gitkeep files in them.

## Project structure
```
.
├── Add_noise.m                    # Script to add babble noise to audio files
├── Chroma_features.m              # Extracts Chroma-based features from audio
├── MFCCs_and_Chroma_features.m    # Extracts both MFCCs and Chroma features
├── MFCCs_features.m               # Extracts MFCCs only
├── Project.m                      # Main script
├── babble.wav                     # Babble noise sample
├── README.md                      # Project documentation
├── code/                          # Auxiliary functions for feature extraction and processing
│   └── (helper functions)
├── data/                          # Dataset organized by genre
│   ├── first_genre/
│   │   ├── train/                 # Training audio files for first genre
│   │   └── test/                  # Testing audio files for first genre
│   ├── second_genre/
│   │   ├── train/
│   │   └── test/
│   └── third_genre/
│       ├── train/
│       └── test/
└── confusion_matrix_example/      # Example output plots of confusion matrices
    └── matrix_plot.png            # Sample image (can be replaced with your own)
```

## Noise testing
I also added noise (babble.wav file) to music files in the Add_noise.m script in order to test the classifiers performance whith noisy files and to check how much noise impacts on their ability to guess.

## Evaluation
A confusion matrix will be plotted for every classifier using each of the feature sets. This matrix shows:
- Prediction accuracy for each genre
- Comparison between performance on clean vs noisy files

## Requirements
This project requires the following MATLAB toolboxes:
- Audio Toolbox
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- DSP System Toolbox
