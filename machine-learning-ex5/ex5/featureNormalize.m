function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

mu = mean(X);
X_norm = bsxfun(@minus, X, mu); %把数组X各列元素减去各列的均值

sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);

%X_norm就是原矩阵各列元素减去各列均值然后除以各列标准差(就是特征缩放)

% ============================================================

end
