%��ȡѵ������ǩ
fid = fopen('train-labels.idx1-ubyte');
fseek(fid,4,'bof');  %���ļ�ͷ�ƶ�4���ֽ�
label_num = fread(fid,1,'int',0,'b');%��ȡ��ǩ����
train_label = fread(fid); %��ȡ��ǩֵ
fclose(fid);

%��ȡѵ����
fid = fopen('train-images.idx3-ubyte');
fseek(fid,4,'bof');  %���ļ�ͷ�ƶ�4���ֽ�
m = fread(fid,1,'int',0,'b');%��ȡѵ��������
image_size = fread(fid,[1 2],'int',0,'b');%��ȡ���ع�ģ
train_data = fread(fid,[image_size(1)*image_size(2) m])';  %��ȡѵ������
fclose(fid);


%չʾǰ100��ͼ��
displayData(train_data(1:100,:));


