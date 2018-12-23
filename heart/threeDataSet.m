function [X_train,y_train,X_cv,y_cv,X_test,y_test] = threeDataSet(X,y,cv_percent)
% 1.把原始数据集分为训练集，交叉验证集，测试集
m = size(X,1); 
cvAndTest_num = m*cv_percent %验证集和测试集的个数
train_num = m-2*cvAndTest_num

rondom = randperm(m)';
X_random = X(rondom,:);  %打乱数据集排序
y_random = y(rondom,:);

X_train = X_random(1:train_num,:);
X_cv = X_random((train_num+1):(train_num+cvAndTest_num),:);
X_test = X_random(((train_num+1+cvAndTest_num)):end,:);

y_train = y_random(1:train_num,:);
y_cv = y_random((train_num+1):(train_num+cvAndTest_num),:);
y_test = y_random(((train_num+1+cvAndTest_num)):end,:);
end

