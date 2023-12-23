function [total_,filted,seg_merged,fin_loc]=calcHBTemplate(S,bz,az)
%�����źŶε�����ģ��
    [avg_HB_length,filted]=calcAvgHBlength(S,bz,az);%�����ź�S��ƽ������
    %filted=filted(100:length(filted));%ǰ100������ܳ����쳣������ȥ��
    wwidth=floor(avg_HB_length);
    half_width=floor(wwidth/2);
    topPoints=findToppoints(filted,1,length(filted));%�ҳ��������ֵһ������м���ֵ��
    cnt=length(topPoints(1,topPoints(1,:)~=0));%����topPoints�еķǿ�ֵ������
   
    if cnt==1 && topPoints(2,1)<=half_width
        topPoints=findToppoints(filted,topPoints(2,1)+half_width,len_signal);%�ҳ�ȥ����ǰ����һ����������ʣ�²��ִ������ֵһ��ļ���ֵ��
    else
        if cnt==1 && topPoints(2,1)>len_signal-half_width
            topPoints=findToppoints(filted,1,topPoints(2,1)-half_width);
        end
    end
    avg_amplitude=mean(topPoints(1,1:cnt));%����topPoints�еĵ�ķ���ƽ��ֵ

    temp_points=topPoints(:,topPoints(1,:)>=avg_amplitude);%Ѱ��topPoints�з�ֵ����avg_amplitude�ĵ�

    len=length(temp_points(1,:));
    if len==0 %�˲���������г����쳣��ֵ��ʱ�����len����0
        disp('In calcHBTemplate, length of temp_points is 0');
        return;
    end
    
    %ȥ���������������������2*Li/3�ĵ�
    temp_loc=temp_points(2,1);
    fin_loc=zeros(1,len);
    fin_loc(1)=temp_loc;
    t=2;
    length_threshold=2*avg_HB_length/3;
    for k=2:len  %��temp_points���ҳ��������2Li/3���е�ĺ�����
        if temp_points(2,k)-temp_loc > length_threshold
            fin_loc(t)=temp_points(2,k);
            t=t+1;
            temp_loc=temp_points(2,k);
        end
    end
    
    fin_loc=fin_loc(fin_loc(:)~=0);%ȥ��������

    %��fin_loc�еĵ�λ���ģ�ȡ���ΪLi�Ĵ��ڣ�������Щ���ڵ�ƽ��ֵ
    len=length(fin_loc);
    len_filted=length(filted);
    
    total_=zeros(1,2*half_width+1);
    for k=1:len
        to_start=fin_loc(k)-1;
        to_end=len_filted-fin_loc(k);
        if to_start < half_width
            current_window=[zeros(1,half_width-to_start),filted(1:fin_loc(k)+half_width)];
            total_=total_+current_window;
            continue;
        end

        if to_end < half_width
            current_window=[filted(fin_loc(k)-half_width:len_filted),zeros(1,half_width-to_end)];
            total_=total_+current_window;
            continue;
        end
    
        current_window=filted(fin_loc(k)-half_width:fin_loc(k)+half_width);
        total_=total_+current_window;
    end
    seg_merged=len;
    total_=total_/len;
end
