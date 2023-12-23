function [total_,filted,seg_merged,fin_loc]=calcHBTemplate(S,bz,az)
%计算信号段的心跳模板
    [avg_HB_length,filted]=calcAvgHBlength(S,bz,az);%估算信号S的平均心率
    %filted=filted(100:length(filted));%前100个点可能出现异常，尝试去除
    wwidth=floor(avg_HB_length);
    half_width=floor(wwidth/2);
    topPoints=findToppoints(filted,1,length(filted));%找出大于最大值一半的所有极大值点
    cnt=length(topPoints(1,topPoints(1,:)~=0));%计算topPoints中的非空值点数量
   
    if cnt==1 && topPoints(2,1)<=half_width
        topPoints=findToppoints(filted,topPoints(2,1)+half_width,len_signal);%找出去除最前方的一个心跳波后剩下部分大于最大值一般的极大值点
    else
        if cnt==1 && topPoints(2,1)>len_signal-half_width
            topPoints=findToppoints(filted,1,topPoints(2,1)-half_width);
        end
    end
    avg_amplitude=mean(topPoints(1,1:cnt));%计算topPoints中的点的幅度平均值

    temp_points=topPoints(:,topPoints(1,:)>=avg_amplitude);%寻找topPoints中幅值大于avg_amplitude的点

    len=length(temp_points(1,:));
    if len==0 %滤波后的数据中出现异常大值点时会造成len等于0
        disp('In calcHBTemplate, length of temp_points is 0');
        return;
    end
    
    %去除不满足两点横向距离大于2*Li/3的点
    temp_loc=temp_points(2,1);
    fin_loc=zeros(1,len);
    fin_loc(1)=temp_loc;
    t=2;
    length_threshold=2*avg_HB_length/3;
    for k=2:len  %从temp_points中找出距离大于2Li/3所有点的横坐标
        if temp_points(2,k)-temp_loc > length_threshold
            fin_loc(t)=temp_points(2,k);
            t=t+1;
            temp_loc=temp_points(2,k);
        end
    end
    
    fin_loc=fin_loc(fin_loc(:)~=0);%去除空数据

    %以fin_loc中的点位中心，取宽度为Li的窗口，并求这些窗口的平均值
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
