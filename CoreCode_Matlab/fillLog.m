function [y]=fillLog(y,n,m)
%将模板信号的尾部采取指对数填充法进行扩展
%y：模板信号
%n:扩充的点数
%m:考虑的历史点数
    num=0;
    len=length(y);
    y=[y,zeros(1,n)];
    for k=1:n
        for t=1:m
            num=num+(0.6*0.25^(t-1))*(y(len+k-t)-y(len+k-t-1));
        end
        y(len+k)=y(len+k-1)+num;
        num=0;
    end
end 
    