fid = fopen('xigua_2.txt');
#色泽,根蒂,敲声,纹理,脐部,触感,密度,含糖率,好瓜,0
#A = csvread('xigua.txt');
#A = A(2:end,[7,8,10]); %1好瓜  2差瓜
#for i=1:7
#  C = textscan(fid,'%s %s %s %s %s %s %d','delimiter',',');
#end

C = cell(18,7);
for i=1:18
  C(i,:) = strsplit(fgetl(fid),',');
end
fclose(fid);

#获取6个属性下的各个取值,第一列是属性名,其他列为属性值
X=zeros(17,6); #X值为对应feature属性下标
feature = C(1,[1:end-1])';
for i=1:6
  for j=2:18
    if(length(feature(i,:))==1)
        feature{i,2} = C{j,i};
        X(j-1,i) = 2;
    else
        flag = false; #是否包含在里面
        index = 0;  
        for n=2:length(feature(i,:))
      
           if(strcmp(feature{i,n},C{j,i}))
              flag = true;
              X(j-1,i) = n;
              break;
           else
              if(isempty(feature{i,n}))
                  index = n;
                  break;
              end
           end
        end
        
        if(index==0)
          index = length(feature(i,:)) + 1;
        end
        
        if(!flag)
          feature{i,index} = C{j,i};
          X(j-1,i) = index;
        end
    end
  end
end
X_fv=C(2:end,1:end-1); #字符串的值
y = str2num(cell2mat(C(2:end,end)));
label = [1,2]; %1好瓜 2坏瓜

feature_len = zeros(size(feature,1),1);
for i=1:size(feature,1)
  index = 0;
  for j=1:length(feature(i,:))
      if(!isempty(feature{i,j}))
          index++;
      end
  end
  feature_len(i) = index;
end

#分训练集和交叉验证集
X_train = [X(1:5,:);X(9:13,:)];
y_train = [y(1:5);y(9:13)];
X_cv = [X(6:8,:);X(14:17,:)];
y_cv = [y(6:8);y(14:17)];

#初始化决策树结构
p.name='test';
dtree=struct('isNode',0,'nodeValue',0,'bestF_index',0,'map',containers.Map(0,p));

#训练决策树
my_tree = ex_dtree(X_train,y_train,1:size(X,2),feature_len,label,dtree);

#训练队列模式的决策树
queue_tree = ex_queueTree(X_train,y_train,1:size(X,2),feature_len,label);

fprintf('start enter .\n');



#测试
m = size(X_cv,1);
for i=1:m
  fprintf('开始测试,按回车继续.\n');
  pause;
  predict_value = predict_dtree(X_cv(i,:),my_tree);
  #predict_value = predict_queueTree(X_cv(i,:),queue_tree,1,1);
  fprintf('\n第%d个用例,实际值:%d ,预测值: %d\n', i,y_cv(i),predict_value);
end
