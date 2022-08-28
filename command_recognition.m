%{
Files:
1. 'recorder.m' : take the recording, and the data is saved
2. 'save_samples.m' : for cropping samples, follow the instructions 
3. 'sort_files.m' : for manually classifying the cropped samples
4. 'dataset_gen.m' : generate the dataset for training network model
5. 'train.m' : train the neural network model
6. 'command_recognition.m' : speech recognition from microphone

Test your newly trained command detection network on audio stream from 
your microphone. If you have not trained a network, then type 
load('trained.mat') at the command line to load a pretrained network and 
the parameters required to classify live, streaming audio. Try speaking one 
of the speech commands. Then, try one of the unknown words,

Specify the audio sampling rate and classification rate in Hz and create an 
audio device reader to read audio from your microphone.
%}

clear all, close all, clc

load('trained.mat');

fs = 16e3;
classificationRate = 20;
audioIn = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/classificationRate));

%{
Specify parameters for the streaming spectrogram computations and initialize 
a buffer for the audio. Extract the classification labels of the network 
and initialize buffers of half a second for the labels and classification 
probabilities of the streaming audio. Use these buffers to build 'agreement' 
over when a command is detected using multiple frames over half a second.
%}

frameDuration = 0.0128;
hopDuration = 0.00512;
numBands = 40;
epsil = 1e-6;

frameLength = round(frameDuration*fs);
hopLength = round(hopDuration*fs);
waveBuffer = zeros([fs,1]);

labels = trainedNet.Layers(end).ClassNames;
YBuffer(1:classificationRate/2) = "background";
probBuffer = zeros([numel(labels),classificationRate/2]);

h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);


while ishandle(h)

    % Extract audio samples from audio device and add to the buffer.
    x = audioIn();
    waveBuffer(1:end-numel(x)) = waveBuffer(numel(x)+1:end);
    waveBuffer(end-numel(x)+1:end) = x;
    
    % Compute the spectrogram of the latest audio samples.
    spec = myAuditorySpectrogram(waveBuffer,fs, ...
        'WindowLength',frameLength, ...
        'OverlapLength',frameLength-hopLength, ...
        'NumBands',numBands, ...
        'Range',[50,7000], ...
        'WindowType','Hann', ...
        'WarpType','Bark', ...
        'SumExponent',2);
    spec = log10(spec + epsil);
    a = size(spec);
    spec = spec(:,1:imageSize(2));

    % Classify the current spectrogram, save the label to the label buffer,
    % and save the predicted probabilities to the probability buffer.
    [YPredicted,probs] = classify(trainedNet,spec,'ExecutionEnvironment','cpu');
    YBuffer(1:end-1)= YBuffer(2:end);
    YBuffer(end) = YPredicted;
    probBuffer(:,1:end-1) = probBuffer(:,2:end);
    probBuffer(:,end) = probs';

    % Plot the current waveform and spectrogram.
    subplot(2,1,1);
    plot(waveBuffer)
    axis tight
    ylim([-0.2,0.2])

    subplot(2,1,2)
    pcolor(spec)
    %caxis([specMin+2 specMax])
    shading flat

 %{
 Now do the actual command detection by performing a very simple
 thresholding operation. Declare a detection and display it in the
 figure title if all of the following hold:
 1) The most common label is not |background|.
 2) At least |countThreshold| of the latest frame labels agree.
 3) The maximum predicted probability of the predicted label is at least |probThreshold|.
 Otherwise, do not declare a detection.
 %}
    
    [YMode,count] = mode(YBuffer);
    countThreshold = ceil(classificationRate*0.2);
    maxProb = max(probBuffer(labels == YMode,:));
    probThreshold = 0.7;
    subplot(2,1,1);
    if YMode == "background" || count<countThreshold || maxProb < probThreshold
        title(" ")
    else
        title(YMode,'FontSize',20)
    end

    drawnow

end

%{
REFERENCES
[1] Warden P. "Speech Commands: A public dataset for single-word speech recognition", 2017. 
Available from http://download.tensorflow.org/data/speech_commands_v0.01.tar.gz. 
Copyright Google 2017. The Speech Commands Dataset is licensed under the 
Creative Commons Attribution 4.0 license, available here: 
https://creativecommons.org/licenses/by/4.0/legalcode.
%}
