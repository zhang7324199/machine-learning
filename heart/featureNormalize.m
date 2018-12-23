function [X_norm, mu, var] = featureNormalize(X)
% 用训练集数据做规范化数据(X-mean)/std(X)
	mu = mean(X);
	var = std(X);
	X_norm = bsxfun(@rdivide, bsxfun(@minus, X, mu), var);
end