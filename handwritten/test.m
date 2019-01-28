%读取训练集标签
fid = fopen('train-labels.idx1-ubyte');
fseek(fid,4,'bof');  %重文件头移动4个字节
label_num = fread(fid,1,'int',0,'b');%读取标签数量
train_label = fread(fid); %读取标签值
fclose(fid);

%读取训练集
fid = fopen('train-images.idx3-ubyte');
fseek(fid,4,'bof');  %重文件头移动4个字节
m = fread(fid,1,'int',0,'b');%读取训练集数量
image_size = fread(fid,[1 2],'int',0,'b');%读取像素规模
train_data = fread(fid,[image_size(1)*image_size(2) m])';  %读取训练数据
fclose(fid);


%展示前100张图像
displayData(train_data(1:100,:));


