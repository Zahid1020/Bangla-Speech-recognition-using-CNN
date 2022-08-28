%{
Files:
1. 'recorder.m' : take the recording, and the data is saved
2. 'save_samples.m' : for cropping samples, follow the instructions 
3. 'sort_files.m' : for manually classifying the cropped samples
4. 'dataset_gen.m' : generate the dataset for training network model
5. 'train.m' : train the neural network model
6. 'command_recognition.m' : speech recognition from microphone

Run this section of the code first, the sound file is loaded in the
workspace. Then open the variable in matlab signal analyzer app, and crop
off the required parts of the data. After selecting the required parts,
just export the data to the workspace, and then run the following section
%}

clear all; close all; clc

[sound,~] = audioread('Original Data\4.wav'); % specify file name here

%%

myvars = who;
Fs = 16000;

for idx=1:length(myvars)
    
    sample = eval(char(myvars(idx)));
    filename = ['book_',int2str(idx),'.wav'];
        
    audiowrite(filename,sample, Fs);
    
end

disp('Cropped samples saved');

