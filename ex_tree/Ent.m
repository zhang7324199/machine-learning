function [value] = Ent(X,y,label)
  m = size(X,1);
  value = 0;
  for i=1:length(label)
      pk = sum(y==label(i))/m;
      if(pk==0)
        value += 0;
      else
        value += (-pk*log2(pk));
      end
      
  end
end
