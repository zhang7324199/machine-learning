Queue;
add('a');
add('b');
add('c');
flag = true;
while(!isEmpty())
  fprintf('%s\n',pull());
  if(flag)
    add('hehe');
    flag = false;
  end
end