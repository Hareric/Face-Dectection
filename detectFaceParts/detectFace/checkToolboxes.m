function ret = checkToolboxes(req)
% 检验包是否导入
info = ver;
s=size(info);

flg = zeros(size(req));
reqSize = size(req,2);

for i=1:s(2)
 for j=1:reqSize
  if( strcmpi(info(1,i).Name,req{1,j}) )
   flg(1,j)=1;
  end
 end
end
ret = prod(flg);
