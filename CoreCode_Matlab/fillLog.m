function [y]=fillLog(y,n,m)
%��ģ���źŵ�β����ȡָ������䷨������չ
%y��ģ���ź�
%n:����ĵ���
%m:���ǵ���ʷ����
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
    