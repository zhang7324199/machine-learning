function [best_C,best_sigma] = dataSetSurf(C,sigma,mu, var,positive,negative,X,y,X_cv,y_cv)
	X_norm = bsxfun(@rdivide, bsxfun(@minus, X, mu), var);
	X_cv_norm = bsxfun(@rdivide, bsxfun(@minus, X_cv, mu), var);
	cost_value = zeros(length(sigma),length(C));
	cost_cv_value = zeros(length(sigma),length(C));
	
  cost = -1.0;C_t=0;sigma_t=0;
  cv_cost = -1.0;C_cv=0;sigma_cv=0;
  for i=1:length(sigma)
		for j=1:length(C)
			model = svmTrain(X_norm, y, C(j),positive,negative, @(x1,x2)gaussianKernel(x1,x2,sigma(i)));  %训练模型
			
			pred = svmPredict(model,positive,negative, X_norm);  
			cost_value(i,j)= sum(y==pred)/size(y,1)*100;%训练集的预测正确率
			
			cv_pred = svmPredict(model,positive,negative, X_cv_norm);
			cost_cv_value(i,j)= sum(y_cv==cv_pred)/size(y_cv,1)*100;%交叉验证集预测正确率
      
      if cost_value(i,j)>cost
        cost = cost_value(i,j);
        C_t=C(j);
        sigma_t=sigma(i);
      end
      if cost_cv_value(i,j)>cv_cost
        cv_cost = cost_cv_value(i,j);
        C_cv=C(j);
        sigma_cv=sigma(i);
      end
    %  cost_value(i,j),cost_cv_value(i,j),C(j),sigma(i)
		end
	end



	surf(C,sigma,cost_value,'FaceColor','b');
	xlabel('C'); ylabel('sigma');zlabel('cost_value');
	hold on;
	surf(C,sigma,cost_cv_value,'FaceColor','r');
	hold off;
  
  fprintf('训练集最大精度=%f, C=%f, sigma=%f\n',cost,C_t,sigma_t);
  fprintf('交叉验证集最大精度=%f, C=%f, sigma=%f\n',cv_cost,C_cv,sigma_cv);
	best_C=C_cv;
	best_sigma=sigma_cv;
end