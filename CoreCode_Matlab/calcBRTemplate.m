function [total_,filted,seg_merged,fin_loc]=calcBRTemplate(S,bz,az)
    %��ȡ�����ź�ģ��
    %����ƽ����������
    filted=filtHB(S,bz,az);
    len_signal=length(filted);
    top_points=findACFToppoints(filted);%ACF��ֵ��
    cycle_lengths=diff(top_points,1,2);
    temp_lengths=cycle_lengths(cycle_lengths(:)>=50);
    temp_lengths=temp_lengths(temp_lengths(:)<=375);
    len=sum(temp_lengths)/length(temp_lengths);%ƽ����������
    half_width=floor(len/2);
    
    [topPoints]=findToppoints(filted,1,length(filted));%�ҳ��������ֵһ��ļ���ֵ��
    cnt=length(topPoints(1,topPoints(1,:)~=0));%����topPoints�еķǿ�ֵ������
    
    if cnt==1 && topPoints(2,1)<=half_width
        topPoints=findToppoints(filted,topPoints(2,1)+half_width,len_signal);%�ҳ�ȥ����ǰ����һ����������ʣ�²��ִ������ֵһ��ļ���ֵ��
    else
        if cnt==1 && topPoints(2,1)>len_signal-half_width
            topPoints=findToppoints(filted,1,topPoints(2,1)-half_width);
        end
    end
    cnt=length(topPoints(1,topPoints(1,:)~=0));%����topPoints�еķǿ�ֵ������
    avg_amplitude=mean(topPoints(1,1:cnt));%����topPoints�еĵ�ķ���ƽ��ֵ
    topPoints=topPoints(2,topPoints(1,:)>=avg_amplitude);%Ѱ��topPoints�з�ֵ����avg_amplitude�ĵ�
    
    %ȥ���������������������2*Li/3�ĵ�
    temp_loc=topPoints(1);
    len_topPoints=length(topPoints);
    fin_loc=zeros(1,len_topPoints);
    fin_loc(1)=temp_loc;
    t=2;
    length_threshold=2*len/3;
    for k=2:len_topPoints  %��temp_points���ҳ��������2Li/3���е�ĺ�����
        if topPoints(k)-temp_loc > length_threshold
            fin_loc(t)=topPoints(k);
            t=t+1;
            temp_loc=topPoints(k);
        end
    end
    
    fin_loc=fin_loc(fin_loc(:)~=0);%ȥ��������
    topPoints=fin_loc;
    
     %�ź��ںϣ�����������������ڽ���ƽ�����õ������ź�ģ��
     fin=length(topPoints);
     total_length=1+half_width*2;
     total_=zeros(1,total_length);
     
     for k=1:fin
         if topPoints(k)<=half_width
             temp_len=topPoints(1)+half_width;
             current_window=[zeros(1,total_length-temp_len),filted(1:temp_len)];
             total_=total_+current_window;
             continue;
         end
         if topPoints(k)>len_signal-half_width
             temp_start=topPoints(fin)-half_width;
             temp_len=len_signal-temp_start+1;
             current_window=[filted(temp_start:len_signal),zeros(1,total_length-temp_len)];
             total_=total_+current_window;
             continue;
         end
         temp_start=topPoints(k)-half_width;
         temp_end=topPoints(k)+half_width;
         current_window=filted(temp_start:temp_end);
         total_=total_+current_window;
     end
     total_=total_/fin;
     seg_merged=fin;
end