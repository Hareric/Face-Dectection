% 创建探测器
% detector = buildDetector( thresholdFace, thresholdParts, stdsize )
% detector.detector(1) 左眼探测器
% detector.detector(2) 右眼探测器
% detector.detector(3) 嘴巴探测器
% detector.detector(4) 鼻子探测器
% detector.detector(5) 人脸探测器
%Output parameter:
% detector: 探测器
%Input parameters:
% thresholdFace (可选): 面部检测器的合并阈值 (默认值为1)
% thresholdParts (可选): 面部五官检测器的合并阈值  (默认值为1)
% maxS (可选): 已归一化后的脸的大小 (默认值为[])
% minS (可选): 已归一化后的脸的大小 (默认值为[])

function detector = buildDetector( thresholdFace, thresholdParts, maxS, minS )

if( nargin < 1 )
    thresholdFace = 1;
end

if( nargin < 2 )
    thresholdParts = 1;
end
if( nargin < 3 )
    maxS = [];
end
if( nargin < 4 )
    minS = [];
end
nameDetector = {'LeftEye'; 'RightEye'; 'Mouth'; 'Nose'; };
detector.stdsize = 176;
detector.detector = cell(5,1);
for k=1:4
    detector.detector{k} = vision.CascadeObjectDetector(char(nameDetector(k)), 'MergeThreshold', thresholdParts);
end

detector.detector{5} = vision.CascadeObjectDetector('FrontalFaceCART', 'MergeThreshold', thresholdFace, 'MaxSize', [maxS maxS], 'MinSize', [minS minS]);
