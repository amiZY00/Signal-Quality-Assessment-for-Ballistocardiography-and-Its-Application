function [top_points]=findACFToppoints(filted)
%Ѱ�Ҿ����˲�����ź����е�����غ����ļ�ֵ��λ�ã���Щ��ֵ��Ķ������£�����غ�����������Ϊ0������ĳ��ȳ���4���������е����ֵ
%filted���˲�����ź�����
    [acf,lags,bounds] = autocorr(filted,length(filted)-1);
    len=length(acf);
    start=1;
    temp_max_points=zeros(2,50);
    r=1;
    t=1;
    k=1;
    while 1
        while k<=len && acf(k)>bounds(2) && acf(k)<bounds(1)  %���������������ڵĵ�
            k=k+1;
        end
    
        if k>len
            break;
        end
    
        start=k;
        if acf(k)>=bounds(1)   
            while k<=len && acf(k)>=bounds(1)  %�ҵ��������������Ͻ����������
                k=k+1;
            end
            fin=k;
            if (fin-start)>=4
                [C,target_loc]=max(acf(start:fin));
                temp_max_points(1,r)=start+target_loc-1;
                r=r+1;
            end
        else
            while k<=len && acf(k)<=bounds(2)  %�ҵ�С�����������½����������
                k=k+1;
            end
            fin=k;
            if (fin-start)>=4
                [C,target_loc]=min(acf(start:fin));
                temp_max_points(2,t)=start+target_loc-1;
                t=t+1;
            end
        end
    end
    top_points=temp_max_points;
end