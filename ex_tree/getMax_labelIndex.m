function[max_index,max_num] = getMax_labelIndex(X,y,label)
      max_index = 0;max_num = 0;
      for i=1:length(label)
        total_num = sum(y==label(i));
        if(total_num>max_num)
          max_index = i;
          max_num = total_num;
        end
      end
end
