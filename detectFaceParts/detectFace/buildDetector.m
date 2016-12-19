% ����̽����
% detector = buildDetector( thresholdFace, thresholdParts, stdsize )
% detector.detector(1) ����̽����
% detector.detector(2) ����̽����
% detector.detector(3) ���̽����
% detector.detector(4) ����̽����
% detector.detector(5) ����̽����
%Output parameter:
% detector: ̽����
%Input parameters:
% thresholdFace (��ѡ): �沿������ĺϲ���ֵ (Ĭ��ֵΪ1)
% thresholdParts (��ѡ): �沿��ټ�����ĺϲ���ֵ  (Ĭ��ֵΪ1)
% maxS (��ѡ): �ѹ�һ��������Ĵ�С (Ĭ��ֵΪ[])
% minS (��ѡ): �ѹ�һ��������Ĵ�С (Ĭ��ֵΪ[])

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
