%#codegen

faceDetector = vision.CascadeObjectDetector();

cam = webcam;

H = figure(1);

while ishghandle(H)
    
    % Read a video frame and run the detector.
    videoFrame      = cam.snapshot();
    bbox            = step(faceDetector, videoFrame);

    % Draw the returned bounding box around the detected face.
    videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
    if ishghandle(H)
        imshow(videoOut), title('Detected face');
    end
    
    drawnow
    pause(0.2);
    
end

clear cam;