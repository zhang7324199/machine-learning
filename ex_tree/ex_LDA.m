#fid = fopen('xigua.txt');
A = csvread('xigua.txt');
A = A(2:end,[7,8,10]); %1好瓜  2差瓜
X=A(:,[1,2]);
y=A(:,3);

x1 = X(find(y==1),:);
x2 = X(find(y==2),:);
u1 = mean(x1);
u2 = mean(x2);

SW = ((x1-u1)'*(x1-u1))+((x2-u2)'*(x2-u2));
SB = (u1-u2)'*(u1-u2);

[V,D] = eig(inv(SW)*SB);
[d,ind] = sort(diag(D));
w = V(:,ind(end));

x_s = X*w;
x_s1 = x_s(find(y==1),:);
x_s2 = x_s(find(y==2),:);

figure 1;
hold on;
plot(x1(:,1),x1(:,2),'g+');
plot(x2(:,1),x2(:,2),'bx');
plot([u1(1)],[u1(2)],'go');
plot([u2(1)],[u2(2)],'bo');
axis([0 1 0 1]);


x_s1 = x_s1*w';
x_s2 = x_s2*w';
X = x_s*w';
plot(x_s1(:,1),x_s1(:,2),'g+');
plot(x_s2(:,1),x_s2(:,2),'bx');
plot(X(:,1),X(:,2),'r');
axis([0 1 0 1]);
hold off;

