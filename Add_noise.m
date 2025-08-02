% this script adds noise to test files
disp('adding noise to test files...')

% reading the noise file (babble.wav)
[babble,fs_babble] = audioread('babble.wav');

% doubling babble because the file is shorter than some songs
babble = [babble; babble];

% applying noise to test data
firstGenreFiles = dir([pwd,'\data\first_genre\test\*.mp3']);
% making a new directory for noisy files
dos(['mkdir ', 'data\first_genre\test\noisy\']);
for i=1:size(firstGenreFiles,1)
    [y,fs] = audioread(firstGenreFiles(i).name);
    % check if mono
    if size(y,2) == 2
        y = sum(y,2)/2;
    end
    [sig,noise,h] = sigmerge(y,babble(1:length(y)),5);
    sig = rescale(sig,-1,1); 
    audiowrite([pwd,'\data\first_genre\test\noisy\',firstGenre,mat2str(i),'noisy.mp3'],sig,fs)
end

secondGenreFiles = dir([pwd,'\data\second_genre\test\*.mp3']);
dos(['mkdir ', 'data\second_genre\test\noisy\']);
for i=1:size(secondGenreFiles,1)
    [y,fs] = audioread(secondGenreFiles(i).name);
    if size(y,2) == 2
        y = sum(y,2)/2;
    end
    [sig,noise,h] = sigmerge(y,babble(1:length(y)),5);
    sig = rescale(sig,-1,1);
    audiowrite([pwd,'\data\second_genre\test\noisy\',secondGenre,mat2str(i),'noisy.mp3'],sig,fs)
end

thirdGenreFiles = dir([pwd,'\data\third_genre\test\*.mp3']);
dos(['mkdir ', 'data\third_genre\test\noisy\']);
for i=1:size(thirdGenreFiles,1)
    [y,fs] = audioread(thirdGenreFiles(i).name);
    if size(y,2) == 2
        y = sum(y,2)/2;
    end
    [sig,noise,h] = sigmerge(y,babble(1:length(y)),5);
    sig = rescale(sig,-1,1);
    audiowrite([pwd,'\data\third_genre\test\noisy\',thirdGenre,mat2str(i),'noisy.mp3'],sig,fs)
end