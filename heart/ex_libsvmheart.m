%https://blog.csdn.net/Christ_123/article/details/63251914  libsvm的具体参数说明

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


model = svmtrain(y_train, X_train_norm,['-g 0.51','-c 0.01']);

[train_pred, t_a, d_P] = svmpredict(y_train, X_train_norm, model);
fprintf('%f训练集预测的精度=%f\n',t_a(1),sum(y_train==train_pred)/size(y_train,1)*100);

X_cv_norm = bsxfun(@rdivide, bsxfun(@minus, X_cv, mu), var);
[cv_pred, accuracy_P, dec_values_P] = svmpredict(y_cv, X_cv_norm, model);
fprintf('%f,交叉验证集预测的精度=%f\n',accuracy_P(1),sum(y_cv==cv_pred)/size(y_cv,1)*100);