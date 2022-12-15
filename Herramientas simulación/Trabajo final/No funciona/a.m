foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'NumTrainingFrames', 50);

videoReader = VideoReader('downtown_short.mp4');
for i = 1:150
    frame = readFrame(videoReader); % read the next video frame
    foreground = step(foregroundDetector, frame);
    figure; imshow(frame); title('Video Frame');
end


figure; imshow(foreground); title('Foreground');