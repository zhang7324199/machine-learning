function[predict_value] = predict_dtree(x,tree)
    #x是1*n向量
    #先判断是否是叶子节点，是则直接输出
    if(tree.isNode)
      predict_value = tree.nodeValue;
    else
      #不是的话,通过besfF,递归下个树
      key = x(tree.bestF_index);
      predict_value = predict_dtree(x,tree.map(key));
    end
end