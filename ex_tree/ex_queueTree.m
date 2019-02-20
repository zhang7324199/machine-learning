function[queue_tree] = ex_queueTree(X,y,X_cv,y_cv,feature_index_collect,feature_len,label)
    #用队列结构实现决策树
    #队列里的元素为一个节点:包含(训练集，属性集，当前层数,父节点的索引(被划分的属性索引),被划分的属性值)
    #用一个原胞数组存储结果行数表示层数，原胞值为各个节点,节点包含（是否是子节点,该节点结果值,被划分的属性值,划分的属性索引（儿子索引）,父亲节点索引，当前层数,当前训练集）
    #遍历队列，每次取出节点，封装到元胞数组,如果需要划分则把划分的几个节点放入队列，继续循环队列直到队列为空

    Queue;
    #首先往队列加个根节点:queueList
    node=struct('X',X,'y',y,'feature_index_collect',feature_index_collect,'currLayer',1,'parentNode',0,'feature_value',0);
    add(node);
    dtree = cell(size(X,2),1); #用于存储的数组
    #开始遍历队列
    fprintf('start queue\n');
    while(!isEmpty())
        node = pull();
        
        m = size(node.X,1);
        kinds = sum(node.y==label(1));
        if(m==kinds || kinds==0)
            dtree_node=struct('isNode',1,'nodeValue',node.y(1),'bestF_index',0,'parentNode',node.parentNode,'feature_value',node.feature_value,'currLayer',node.currLayer,"X",node.X,'y',node.y);
            dtree{node.currLayer,length(dtree(node.currLayer,:))+1} = dtree_node;
            continue;
        end
        
        if(length(node.feature_index_collect)<=0 || sum(sum(node.X(:,node.feature_index_collect)==node.X(1,node.feature_index_collect)))==numel(node.X(:,node.feature_index_collect)))
          max_index = getMax_labelIndex(node.X,node.y,label);
          dtree_node=struct('isNode',1,'nodeValue',label(max_index),'bestF_index',0,'parentNode',node.parentNode,'feature_value',node.feature_value,'currLayer',node.currLayer,'X',node.X,'y',node.y);
          dtree{node.currLayer,length(dtree(node.currLayer,:))+1} = dtree_node;
          continue;
        end
        
        #找出好的划分属性
        bestF_index = 0;max_gain_value = 0;
        for i=1:length(node.feature_index_collect)
            gain_value = Gain(node.X, node.y, node.feature_index_collect(i), 2:feature_len(node.feature_index_collect(i)), label);
            if(gain_value>max_gain_value)
                bestF_index = node.feature_index_collect(i);
                max_gain_value = gain_value;
            end
        end
        
        #预剪枝
        #通过验证集判断是否继续划分
        
        
     
        #把划分的节点放入数组中
        dtree_node=struct('isNode',0,'nodeValue',0,'bestF_index',bestF_index,'parentNode',node.parentNode,'feature_value',node.feature_value,'currLayer',node.currLayer,'X',node.X,'y',node.y);
        dtree{node.currLayer,length(dtree(node.currLayer,:))+1} = dtree_node;
        
        
        #遍历每个属性值
        featureValue_array = 2:feature_len(bestF_index);
        for i=1:length(featureValue_array)
           X_sub = node.X(node.X(:,bestF_index)==featureValue_array(i),:);
           y_sub = node.y(node.X(:,bestF_index)==featureValue_array(i));
           if(length(y_sub)<=0)
              #如果划分后该值没有数据集直接放入数组
              max_index = getMax_labelIndex(node.X,node.y,label);        
              dtree_node=struct('isNode',1,'nodeValue',label(max_index),'bestF_index',0,'parentNode',bestF_index,'feature_value',featureValue_array(i),'currLayer',node.currLayer+1,'X',X_sub,'y',y_sub);
              dtree{node.currLayer+1,length(dtree(node.currLayer+1,:))+1} = dtree_node;
              continue;
           else
              #放入队列
              sub_feature_index = node.feature_index_collect(node.feature_index_collect!=bestF_index);
              son_node=struct('X',X_sub,'y',y_sub,'feature_index_collect',sub_feature_index,'currLayer',node.currLayer+1,'parentNode',bestF_index,'feature_value',featureValue_array(i));
              add(son_node);
              continue;
           end
        end
        
    end
    fprintf('end queue\n');
    queue_tree = dtree;
end