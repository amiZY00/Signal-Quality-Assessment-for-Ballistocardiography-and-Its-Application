function [total_,filted,seg_merged,fin_loc]=calcBRTemplate(S,bz,az)
    %获取呼吸信号模板
    %估算平均呼吸速率
    filted=filtHB(S,bz,az);
    len_signal=length(filted);
    top_points=findACFToppoints(filted);%ACF极值点
    cycle_lengths=diff(top_points,1,2);
    temp_lengths=cycle_lengths(cycle_lengths(:)>=50);
    temp_lengths=temp_lengths(temp_lengths(:)<=375);
    len=sum(temp_lengths)/length(temp_lengths);%平均呼吸速率
    half_width=floor(len/2);
    
    [topPoints]=findToppoints(filted,1,length(filted));%找出大于最大值一半的极大值点
    cnt=length(topPoints(1,topPoints(1,:)~=0));%计算topPoints中的非空值点数量
    
    if cnt==1 && topPoints(2,1)<=half_width
        topPoints=findToppoints(filted,topPoints(2,1)+half_width,len_signal);%找出去除最前方的一个呼吸波后剩下部分大于最大值一般的极大值点
    else
        if cnt==1 && topPoints(2,1)>len_signal-half_width
            topPoints=findToppoints(filted,1,topPoints(2,1)-half_width);
        end
    end
    cnt=length(topPoints(1,topPoints(1,:)~=0));%计算topPoints中的非空值点数量
    avg_amplitude=mean(topPoints(1,1:cnt));%计算topPoints中的点的幅度平均值
    topPoints=topPoints(2,topPoints(1,:)>=avg_amplitude);%寻找topPoints中幅值大于avg_amplitude的点
    
    %去除不满足两点横向距离大于2*Li/3的点
    temp_loc=topPoints(1);
    len_topPoints=length(topPoints);
    fin_loc=zeros(1,len_topPoints);
    fin_loc(1)=temp_loc;
    t=2;
    length_threshold=2*len/3;
    for k=2:len_topPoints  %从temp_points中找出距离大于2Li/3所有点的横坐标
        if topPoints(k)-temp_loc > length_threshold
            fin_loc(t)=topPoints(k);
            t=t+1;
            temp_loc=topPoints(k);
        end
    end
    
    fin_loc=fin_loc(fin_loc(:)~=0);%去除空数据
    topPoints=fin_loc;
    
     %信号融合，将多个呼吸采样窗口进行平均，得到呼吸信号模板
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