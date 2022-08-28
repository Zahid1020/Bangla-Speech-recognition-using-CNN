%{
This code is used to take a recording of a data sample of the time duration
specified below. This data has to be processed later for cropping out the
desired samples, sorting them out and creating the dataset.
Files:
1. 'recorder.m' : take the recording, and the data is saved
2. 'save_samples.m' : for cropping samples, follow the instructions 
3. 'sort_files.m' : for manually classifying the cropped samples
4. 'dataset_gen.m' : generate the dataset for training network model
5. 'train.m' : train the neural network model
6. 'command_recognition.m' : speech recognition from microphone
%}

clear all; close all; clc

Fs = 16000;     % sampling rate
nBits = 16;     % bits per sample
nChannels = 1;  % number of audio recorder channels
recObj = audiorecorder(Fs, nBits, nChannels);   
recTime = 15;  % recording duration in seconds

filename = input('Enter filename :','s');
filename = [filename,'.wav'];

% display input prompt
disp('Start Speaking In...');
pause(1);disp('2');
pause(1);disp('1');
disp('NOW!!');
recordblocking(recObj,recTime);
disp('Recording Ended');

myRecording = getaudiodata(recObj);     
%plot(myRecording);              % show the audio data vs time

audiowrite(filename, myRecording, Fs);