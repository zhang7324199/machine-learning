clear;close all;
%读取训练集标签
fid = fopen('train-labels.idx1-ubyte');
fseek(fid,4,'bof');  %重文件头移动4个字节
label_num = fread(fid,1,'int',0,'b');%读取标签数量
y = fread(fid); %读取标签值
fclose(fid);

%读取训练集
fid = fopen('train-images.idx3-ubyte');
fseek(fid,4,'bof');  %重文件头移动4个字节
m = fread(fid,1,'int',0,'b');%读取训练集数量
image_size = fread(fid,[1 2],'int',0,'b');%读取像素规模
X = fread(fid,[image_size(1)*image_size(2) m])';  %读取训练数据
fclose(fid);

%1.把0标签映射成10
y(y==0)=10;

%2.把原始数据集分为训练集，交叉验证集，测试集
[X_train,y_train,X_cv,y_cv,X_test,y_test] = threeDataSet(X,y,0.2);

%3.通过pca降维特征向量,加速算法收敛
fprintf('\n数据降维可能需要几分钟... \n')
[U, S] = pca(X_train(1:10000,:));
K = obtainBestKNum(S,0.95)
Z = projectData(X_train, U, K);
X_rec  = recoverData(Z, U, K);

displayData(X_train(10001:10100,:)); %展示数据
figure;
displayData(X_rec(10001:10100,:)); %展示降维后的数据

%利用降维后的数据,训练神经模型
fprintf('\n开始使用神经网络训练,回车继续... \n')
pause;
options = optimset('MaxIter', 100);
lambda = 1;
input_layer_size=K
hidden_layer_size= round(sqrt(K))+10
num_labels=10
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, Z, y_train, lambda);

fprintf('\n随机初始化theta ...\n')
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('按回车继续查看训练器的精度.\n');
pause;

pred = predict(Theta1, Theta2, Z);
fprintf('\n精度: %f\n', mean(double(pred == y_train)) * 100);

close all;
y_test(y_test==10)=0;
Z_test = projectData(X_test, U, K);
Z_rec  = recoverData(Z_test, U, K);
for i=1:size(X_test,1)
  colormap(flipud(gray));
  example = reshape(X_test(i, :), 28, 28)';
  example_rec = reshape(Z_rec(i, :), 28, 28)';
  subplot(1, 2, 1);
  imagesc(example);
  subplot(1, 2, 2);
  imagesc(example_rec);
  colorbar;
  
  h1 = sigmoid([1 Z_test(i, :)] * Theta1');
  h2 = sigmoid([1 h1] * Theta2');
  [dummy, p_value] = max(h2, [], 2);
  if(p_value==10)
      fprintf('\n实际值:%d ,预测值: %d\n', y_test(i),0);
  else
      fprintf('\n实际值:%d ,预测值: %d\n', y_test(i),p_value);
  end
  fprintf('按回车继续.\n');
  pause;
end
