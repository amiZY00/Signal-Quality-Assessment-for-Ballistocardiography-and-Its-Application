function [topPoints]=findToppoints(S,start,fin)
%从经滤波的序列S的子序列S(start:fin)中找到极大值点
%topPoints：2×2000矩阵，第一行为极大值点纵坐标，第二行为极大值点横坐标
     MIN=min(S(start:fin));
     justified=S+abs(MIN);  %防止因最大值小于0导致计算出错
     c=max(justified(start:fin));
     threshold=c/2;
     k=start;
     t=1;
     topPoints=zeros(2,fin-start+1);
     while k<=fin
         while k<=fin && justified(k)<=threshold
             k=k+1;
         end
         if k>fin
             break;
         end
         temp_start=k;
         while k<=fin && justified(k)>threshold
             k=k+1;
         end
         temp_fin=k-1;
         [C,loc]=max(S(temp_start:temp_fin));
         topPoints(1,t)=C;
         topPoints(2,t)=temp_start+loc-1;
         t=t+1;
     end
end
         