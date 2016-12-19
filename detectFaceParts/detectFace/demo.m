clc;
clear;


reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

img = imread('Test2.png');
detector = buildDetector();
[bbimg, faces] = detectFaceParts(detector,img);
 
for i=1:size(faces,1)
 figure;imshow(faces{i});
end
figure;imshow(bbimg);


