function[my_tree] = ex_dtree(X,y,feature_index,feature_len,label,dtree)
#这个结构体包含,属于哪个属性,取不同属性对应的结果(用map形式),是否是叶子节点
#feature_len 是属性具体值重2开始: 2:length,数组下标是第几个属性
#feature_index 属性集合,里面的值是第几个属性

#步骤
#1.检查是否数据集都属于同一类别是，标记此节点叶子节点
#2.检查是否属性集为空或者数据集在feature_index所在属性集取值一样，标记叶节点，取数据集类别最多的
#3.通过熵找出最好划分的属性
#4.循环该属性下各个属性值,如果该属性值数据集为空，则标记叶子节点，类别取数据集最多
#5.不为空递归
  m = size(X,1);
  kinds = sum(y==label(1));
  if(m==kinds || kinds==0)
      dtree.isNode = true;
      dtree.nodeValue = y(1);
      my_tree = dtree;
      return;
  end
  
  if(length(feature_index)<=0 || sum(sum(X(:,feature_index)==X(1,feature_index)))==numel(X(:,feature_index)))
      max_index = getMax_labelIndex(X,y,label);
      dtree.isNode = true;
      dtree.nodeValue = label(max_index);
      my_tree = dtree;
      return;
  end
  
  #找出好的划分属性
  bestF_index = 0;max_gain_value = 0;
  for i=1:length(feature_index)
      gain_value = Gain(X,y,feature_index(i),2:feature_len(feature_index(i)),label);
      if(gain_value>max_gain_value)
          bestF_index = feature_index(i);
          max_gain_value = gain_value;
      end
  end
  dtree.bestF_index=bestF_index;

  #该不该继续划分?取验证集正确率高的
  #不划分:
  #划分:
  
  featureValue_array = 2:feature_len(bestF_index);
  #遍历每个属性值
  for i=1:length(featureValue_array)
     X_sub = X(X(:,bestF_index)==featureValue_array(i),:);
     y_sub = y(X(:,bestF_index)==featureValue_array(i));
     p.name='test';
     sonTree.map = containers.Map(0,p);
     if(length(y_sub)<=0)
        max_index = getMax_labelIndex(X,y,label);
        sonTree.isNode = true; #是否叶子节点
        sonTree.nodeValue = label(max_index);
        dtree.map(featureValue_array(i)) = sonTree;
     else
        dtree.isNode = false;
        sub_feature_index = feature_index(feature_index!=bestF_index);
        dtree.map(featureValue_array(i)) = ex_dtree(X_sub,y_sub,sub_feature_index,feature_len,label,sonTree);
     end
  end
   my_tree = dtree;
end