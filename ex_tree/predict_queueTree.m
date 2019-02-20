function[predict_value] = predict_queueTree(x,queueTree,currLayer,feature_index)
    #预测队列实现的决策树
    for i=1:length(queueTree(currLayer,:))
       if(!isempty(queueTree{currLayer,i}))
          node = queueTree{currLayer,i}; 
          if(currLayer==1 || (node.parentNode==feature_index && node.feature_value==x(feature_index)))
            if(node.isNode)
              predict_value = node.nodeValue;
            else
              predict_value = predict_queueTree(x,queueTree,node.currLayer+1,node.bestF_index);
            end
            break;
          end
       end
       
    end
end