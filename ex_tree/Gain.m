function [value] = Gain(X,y,feather_index,feather_value,label)
   m = size(X,1);
   value = 0;
   for i=1:length(feather_value)
     if(sum(X(:,feather_index)==feather_value(i))!=0)
        X_d = X(X(:,feather_index)==feather_value(i),:);
        y_d = y(X(:,feather_index)==feather_value(i)); 
       value += sum(X(:,feather_index)==feather_value(i))/m*Ent(X_d,y_d,label);
     end
   end
   value = Ent(X,y,label)-value;
end
