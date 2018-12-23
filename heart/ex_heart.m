addpath('./matlab');
% 使用SVM预测心脏病:大体步骤
h = load('heart.dat');
X = h(:,1:13);
y = h(:,14);
% 1代表没有心脏病  2代表有心脏病
positive = 1;
negative = 2;
% 1.把原始数据集分为训练集，交叉验证集，测试集
[X_train,y_train,X_cv,y_cv,X_test,y_test] = threeDataSet(X,y,0.2);


% 2.用训练集数据做规范化数据(X-mean)/std(X)
[X_train_norm, mu, var] = featureNormalize(X_train);
fprintf('开始SVM训练,请按回车继续。\n');
pause;


% 3.使用SVM算法训练
C = 2,sigma = 3
model = svmTrain(X_train_norm, y_train, C,positive,negative, @(x1,x2)gaussianKernel(x1,x2,sigma));

train_pred = svmPredict(model,positive,negative, X_train_norm);
fprintf('训练集预测的精度=%f\n',sum(y_train==train_pred)/size(y_train,1)*100);

X_cv_norm = bsxfun(@rdivide, bsxfun(@minus, X_cv, mu), var);
cv_pred = svmPredict(model,positive,negative, X_cv_norm);
fprintf('交叉验证集预测的精度=%f\n',sum(y_cv==cv_pred)/size(y_cv,1)*100);

X_test_norm = bsxfun(@rdivide, bsxfun(@minus, X_test, mu), var);
test_pred = svmPredict(model,positive,negative, X_test_norm);
fprintf('测试集预测的精度=%f\n',sum(y_test==test_pred)/size(y_test,1)*100);


% 4.选择交叉验证集测试 哪个C和δ更好
C=0.01:0.5:2;
sigma=0.01:0.5:2;
[best_C,best_sigma] = dataSetSurf(C,sigma,mu,var,positive,negative,X_train,y_train,X_cv,y_cv);


% 5.通过测试集测试误差
model = svmTrain(X_train_norm, y_train, best_C,positive,negative, @(x1,x2)gaussianKernel(x1,x2,best_sigma));
X_test_norm = bsxfun(@rdivide, bsxfun(@minus, X_test, mu), var);
test_pred = svmPredict(model,positive,negative, X_test_norm);
fprintf('测试集预测的精度=%f\n',sum(y_test==test_pred)/size(y_test,1)*100);