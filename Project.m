clear;clc
close all


addpath(genpath(pwd))

WL = 0.5; % window length
SL = 0.3; % step length
ext = 'mp3'; % file extension

answ = inputdlg("Enter first music genre");
firstGenre = answ{1};
answ = inputdlg("Enter second music genre");
secondGenre = answ{1};
answ = inputdlg("Enter third music genre");
thirdGenre = answ{1};

tic % start counting the time

run Add_noise.m
run MFCCs_features.m
run Chroma_features.m
run MFCCs_and_Chroma_features.m

toc % stop counting the time

% removing noisy files directories
disp('removing noisy files...')
dos(['del ', 'data\first_genre\test\noisy\*.mp3']);
dos(['del ', 'data\second_genre\test\noisy\*.mp3']);
dos(['del ', 'data\third_genre\test\noisy\*.mp3']);
dos(['rmdir ', 'data\first_genre\test\noisy\']);
dos(['rmdir ', 'data\second_genre\test\noisy\']);
dos(['rmdir ', 'data\third_Genre\test\noisy\']);