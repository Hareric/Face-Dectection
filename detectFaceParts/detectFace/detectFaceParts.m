% detectFaceParts: detect faces with parts
% 识别人脸并识别出眼睛鼻子嘴巴
% [bbox,bbX,faces,bbfaces] = detectFaceParts(detector,X,thick)
%
%Output parameters:
% bbX: 用矩形标识出头像的原图
% faces: 识别出的人脸列表
% bbfaces: 用矩形标识出的人脸列表
%
%
%Input parameters:
% detector: 探测器
% X: 图形向量矩阵
% thick(可选): 标识人脸的矩形的厚度，默认值为1
% printOrgan(可选):是否标识出五官,默认值为0 不标出
% faceTest(可选):是否进行五官检验，默认值为1 进行检验
function [bbX,faces] = detectFaceParts(detector,X,thick,printOrgan,faceTest)

if( nargin < 3 )
    thick = 3;  % 默认值
end
if( nargin < 4 )
    printOrgan = 0;  % 默认值
end
if( nargin < 5 )
    faceTest = 1;  % 默认值
end

% 探测脸
bbox = step(detector.detector{5}, X);
bbsize = size(bbox);
faceValues = zeros(size(bbox,1),1);

% 在探测脸的基础上 探测五官
stdsize = detector.stdsize;

for k=1:4
    % region 探测范围
    if( k == 1 )
        region = [1,int32(stdsize*2/3); 1, int32(stdsize*2/3)];
    elseif( k == 2 )
        region = [int32(stdsize/3),stdsize; 1, int32(stdsize*2/3)];
    elseif( k == 3 )
        region = [1,stdsize; int32(stdsize/3), stdsize];
    elseif( k == 4 )
        region = [int32(stdsize/5),int32(stdsize*4/5); int32(stdsize/3),stdsize];
    else
        region = [1,stdsize;1,stdsize];
    end
    
    bb = zeros(bbsize);
    for i=1:size(bbox,1)
        XX = X(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
        XX = imresize(XX,[stdsize, stdsize]);
        XX = XX(region(2,1):region(2,2),region(1,1):region(1,2),:);
        
        b = step(detector.detector{k},XX);
        
        if( size(b,1) > 0 )
            faceValues(i) = faceValues(i) + 1;
            
            if( k == 1 )
                b = sortrows(b,1);
            elseif( k == 2 )
                b = flipud(sortrows(b,1));
            elseif( k == 3 )
                b = flipud(sortrows(b,2));
            elseif( k == 4 )
                b = flipud(sortrows(b,3));
            end
            
            ratio = double(bbox(i,3)) / double(stdsize);
            b(1,1) = int32( ( b(1,1)-1 + region(1,1)-1 ) * ratio + 0.5 ) + bbox(i,1);
            b(1,2) = int32( ( b(1,2)-1 + region(2,1)-1 ) * ratio + 0.5 ) + bbox(i,2);
            b(1,3) = int32( b(1,3) * ratio + 0.5 );
            b(1,4) = int32( b(1,4) * ratio + 0.5 );
            bb(i,:) = b(1,:);
        end
    end
    bbox = [bbox,bb];
    
    p = ( sum(bb') == 0 );
    bb(p,:) = [];
end


% 用矩形标识出识别的人脸
bbox = [bbox,faceValues];
if faceTest == 1
    bbox(faceValues<=2,:)=[];  % 五官检验 将人脸有效值小于等于2的 归为无效人脸
end

if( thick >= 0 )
    t = (thick-1)/2;
    t0 = -int32(ceil(t));
    t1 = int32(floor(t));
else
    t0 = 0;
    t1 = 0;
end


if printOrgan ~= 0
    printOrgan = 5;
else
    printOrgan = 1;
end
bbX = X;
boxColor = [[0,255,0]; [255,0,255]; [255,0,255]; [0,255,255]; [255,255,0]; ];
for k=printOrgan:-1:1
    shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',boxColor(k,:));
    for i=t0:t1
        bb = int32(bbox(:,(k-1)*4+1:k*4));
        bb(:,1:2) = bb(:,1:2)-i;
        bb(:,3:4) = bb(:,3:4)+i*2;
        bbX = step(shapeInserter, bbX, bb);
    end
end

% faces

faces = cell(size(bbox,1),1);
for i=1:size(bbox,1)
    faces{i,1} = X(bbox(i,2):bbox(i,2)+bbox(i,4)-1,bbox(i,1):bbox(i,1)+bbox(i,3)-1,:);
end


