%% Initialization

clear all;
close all;
clc

% hardware initialization
init_face_engine();
%global audioIn trainNet imSize
init_voice_engine();
FS = 16000;

% feedback images
global human record speaker;
human = [struct('im',imread('icons\person_0.jpg')),struct('im',imread('icons\person_1.jpg'))];
record = [struct('im',imread('icons\record_0.jpg')),struct('im',imread('icons\record_1.jpg'))];
speaker = [struct('im',imread('icons\speaker_0.jpg')),struct('im',imread('icons\speaker_1.jpg'))];
LOGO = imread('icons\BUET.png');

% feedback audios
welcome = audioread('commands\welcome.wav');
add_more = audioread('commands\add_more.wav');
previous = audioread('commands\previous.wav');
thanks = audioread('commands\thanks.wav');
you_have_added = audioread('Commands\you_have_added.wav');

numbers = zeros(length(audioread('numbers\0.wav')), 10);
for idx = 1:10
    a = audioread(['numbers\',char(string(idx-1)),'.wav']);
    numbers(1:length(a),idx) = a;
end
hundred = audioread('numbers\hundred.wav');
thousand = audioread('numbers\thousand.wav');

% catalog
base = 'catalog';
sub = ['A','B'];
sub_sub = ['A','B','C','D','E'];

disp('Initiation complete');

%% Main loop



clc

voice_input_enable= false;

Interface = figure(1); 

global video_feed person_stat record_stat speaker_stat menu ;

video_feed = subplot(3,3,1); 

person_stat = subplot(3,3,7); 

record_stat = subplot(3,3,8); 

speaker_stat = subplot(3,3,9);

menu = subplot(3,3,[2,3,5,6]);

subplot(person_stat), imshow(human(1).im);
subplot(record_stat), imshow(record(1).im);
subplot(speaker_stat), imshow(speaker(1).im);
subplot(menu), imshow(LOGO), title('BUET Library');

ordered_books =[];
ordered_books_faces = [];



while ishandle(Interface)
    
    
    
    [person, videoFrame] = face_engine();
    
    subplot(video_feed), imshow(videoFrame), drawnow;
    
    subplot(person_stat), imshow(human(person+1).im), drawnow;
    
    if person
        
        disp('Welcome audio playing.');
        feedback_prompt(welcome);
        
        
        number = nan;
        
        disp('Waiting for user voice input');
        disp('Choose between 0-1');
        
        if voice_input_enable
            while isnan(number)
                number = input_prompt();
                if ~isnan(number) && number>1
                   number= nan; 
                end
            end
        else
            number = input('Keyboard Input: ');
        end
        
        
                
        
        disp('voice input complete')
        
        
        
        

        if number == 1
            disp('user has spoken 1')
            while true
                
 
                
                disp('Main Category menu audio playing');
                for idx_main = 1:length(sub)
                    NUM = numbers(:,idx_main+1);
                    
                    path = [base,'\',sub(idx_main),'\'];
                    
                    S = audioread([path,sub(idx_main),'0.wav']);
                    I = imread([path,sub(idx_main),'0.jpg']);
                    
                    disp([path,sub(idx_main),'0.wav']);
                    
                    feedback_prompt(NUM)
                    feedback_prompt_image(S, I, string(idx_main))
                    pause(1);
                end
                
                idx_main = nan;
                
                
                disp('Waiting for user voice input for main category');
                disp('choose between 0-2');
                
                if voice_input_enable
                    while isnan(idx_main)
                        idx_main = input_prompt();
                        if ~isnan(idx_main) && idx_main > 2
                           idx_main = nan; 
                        end
                    end
                else
                    idx_main = input('Keyboard Input: ');
                end
                
                
               
                
                disp('voice input complete')
                
                if idx_main == 0
                    disp('user has spoken 0')
                    break
                    
                else
                    
                    disp('user has spoken:');
                    disp(idx_main);
                    
                    path = [base,'\',sub(idx_main),'\'];
                    disp('path: ');
                    disp(path);
                    
                    while true
                        
                        disp('Sub Category menu audio playing');
                        for idx_sub = 1:length(sub_sub)
                            NUM = numbers(:,idx_sub+1);
                            sub_path = [path,sub_sub(idx_sub),'\'];
                            S = audioread([sub_path,sub_sub(idx_sub),'0.wav']);
                            I = imread([sub_path,sub_sub(idx_sub),'0.jpg']);
                            
                            feedback_prompt(NUM)
                            feedback_prompt_image(S, I, string(idx_sub))
                            pause(1);
                        end
                        
                        idx_sub = nan;
                        
                        
                        disp('Waiting for user voice input for sub category')
                        if voice_input_enable
                            while isnan(idx_sub)
                               idx_sub = input_prompt();
                               if ~isnan(idx_sub) && idx_sub > 5
                                    idx_sub=nan;
                               end
                            end
                        else
                            idx_sub = input('Keyboard Input: ');
                        end
                        
                        if idx_sub == 0
                            disp('user has spoken 0')
                            break
                        else
                            
                            disp('user has spoken:');
                            disp(idx_sub);
                            
                            sub_path = [path,sub_sub(idx_sub),'\'];
                            disp('sub_path: ');
                            disp(sub_path);
                            
                            books_names = dir([sub_path, '*.wav']);
                            
                            
                            books_faces = dir([sub_path, '*.jpg']);
                            
                            disp('amount of books in subfolder:');
                            disp(length(books_faces));
                              
                            
                            while true
                                
                                
                                disp('name of books playing');
                                for idx_book = 2:length(books_names)
                                    
                                    NUM = numbers(:,idx_book);
                                    
                                    S = audioread([sub_path,books_names(idx_book).name]);
                                    I = imread([sub_path,books_faces(idx_book).name]);
                                    
                                    feedback_prompt(NUM)
                                    feedback_prompt_image(S, I, string(idx_book-1))
                                    pause(1);
                                end
                                
                                idx_book=nan;
                              
                            if voice_input_enable
                                while isnan(idx_book)
                                    idx_book = input_prompt();
                                    if ~isnan(idx_book) && idx_book> length(books_names)
                                        idx_book = nan;
                                    end
                                end
                            else
                                idx_book = input('Input: ');
                            end
                                disp('Selected book:');
                                disp([sub_path,books_names(idx_book+1).name]);
                                ordered_books=[ordered_books ; [sub_path,books_names(idx_book+1).name]];
                                ordered_books_faces=[ordered_books_faces ; [sub_path,books_faces(idx_book+1).name]];
                                
                                break;
                                
                                
                            end
                            break;
                        end
                        
                    end
                    
                end
                
            end
        end
        
        
        disp('Number of ordered books');
        disp(size(ordered_books,1));
        disp('Displaying ordered books on GUI');
        for i=1:size(ordered_books,1)
            S = audioread(ordered_books(i,:));
            I = imread(ordered_books_faces(i,:));
            feedback_prompt_image(S, I, string(i));
        end
        
        disp('Program ended with thanks');
        sound(thanks,FS);
        pause(length(thanks)/FS);
        pause(10);
        subplot(menu), imshow(LOGO), title('BUET Library');
    end
end

%% Function Definitions

function number = input_prompt()
global video_feed person_stat record_stat;
global human record;
number = nan;
[person, videoFrame] = face_engine();
subplot(video_feed), imshow(videoFrame), drawnow;
subplot(person_stat), imshow(human(person+1).im), drawnow;
if person
    subplot(record_stat), imshow(record(2).im), drawnow;
    number = voice_engine();
    subplot(record_stat), imshow(record(1).im), drawnow;
end
end

function [] = feedback_prompt_image(play_sound, photo, im_title)
global speaker_stat menu;
global speaker;
subplot(menu), imshow(photo), drawnow;
title(im_title);
subplot(speaker_stat), imshow(speaker(2).im);
sound(play_sound,16000);
pause(length(play_sound)/16000);
subplot(speaker_stat), imshow(speaker(1).im);
end

function [] = feedback_prompt(play_sound)
global speaker_stat;
global speaker;
subplot(speaker_stat), imshow(speaker(2).im);
sound(play_sound,16000);
pause(length(play_sound)/16000);
subplot(speaker_stat), imshow(speaker(1).im);
end

function [] = init_face_engine()
global cam faceDetector;
cam = webcam;
faceDetector = vision.CascadeObjectDetector();
end

function [person, videoFrame] = face_engine()
global cam faceDetector;
videoFrame      = cam.snapshot();
bbox            = step(faceDetector, videoFrame);
if ~isempty(bbox)
    person = 1;
    videoFrame = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
else
    person = 0;
end
end

function [] = init_voice_engine()
global audioIn trainNet imSize
load('trained.mat','trainedNet','imageSize');
fs = 16e3;
classificationRate = 20;
audioIn = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/classificationRate));
trainNet = trainedNet;
imSize = imageSize;
end

function number = voice_engine()
global audioIn trainNet imSize
fs = 16e3;
classificationRate = 20;
frameDuration = 0.0128;
hopDuration = 0.00512;
numBands = 40;
epsil = 1e-6;

frameLength = round(frameDuration*fs);
hopLength = round(hopDuration*fs);
labels = trainNet.Layers(end).ClassNames;

waveBuffer = zeros([fs,1]);
YBuffer(1:classificationRate/2) = "background";
probBuffer = zeros([numel(labels),classificationRate/2]);

number = nan;
tic

while isnan(number)
    
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
    spec = spec(:,1:imSize(2));
    
    % Classify the current spectrogram, save the label to the label buffer,
    % and save the predicted probabilities to the probability buffer.
    [YPredicted,probs] = classify(trainNet,spec,'ExecutionEnvironment','cpu');
    YBuffer(1:end-1)= YBuffer(2:end);
    YBuffer(end) = YPredicted;
    probBuffer(:,1:end-1) = probBuffer(:,2:end);
    probBuffer(:,end) = probs';
    
    [YMode,count] = mode(YBuffer);
    countThreshold = ceil(classificationRate*0.2);
    maxProb = max(probBuffer(labels == YMode,:));
    probThreshold = 0.7;
    
    if YMode == "background" || YMode == "noise" || count<countThreshold || maxProb < probThreshold
    else
        number = str2double(YMode);
        break
    end
    
    elapsed_time = toc;
    if elapsed_time >=10
        break;
    end
    
end
end


