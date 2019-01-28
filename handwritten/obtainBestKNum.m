%获取差异性小于1-min_value的取值k(前K个最大的特征向量)
function k = obtainBestKNum(U,min_value)
  k=1;
  totalValue = sum(sum(U));
  for i=1:size(U,1)
    value = sum(sum(U(1:i,:)))/totalValue;
    if(value>=min_value)
        k=i;
        break;
    end
  end
end
