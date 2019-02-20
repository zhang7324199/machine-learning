global queueList = cell(0);
global startIndex = 1;
global lastIndex = 0;
value='';
function [flag] = add(value)
   global queueList;
   global startIndex;
   global lastIndex;
   lastIndex = lastIndex + 1;
   queueList{lastIndex} = value;
   flag = true;
end

function [value] = pull()
   global queueList;
   global startIndex;
   global lastIndex;
   if(startIndex>lastIndex)
      value = '';
   else
      value = queueList{startIndex};
      startIndex = startIndex + 1;
   end
end

function [flag] = isEmpty()
   global queueList;
   global startIndex;
   global lastIndex;
   if(startIndex>lastIndex)
      flag = true;
   else
      flag = false;
   end
end