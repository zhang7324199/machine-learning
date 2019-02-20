function [num] = digui(number,i)
  if(i==5)
    num = number;
  else
    num = digui(number+2,i+1);
  end
end
