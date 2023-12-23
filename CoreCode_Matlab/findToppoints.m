function [topPoints]=findToppoints(S,start,fin)
%�Ӿ��˲�������S��������S(start:fin)���ҵ�����ֵ��
%topPoints��2��2000���󣬵�һ��Ϊ����ֵ�������꣬�ڶ���Ϊ����ֵ�������
     MIN=min(S(start:fin));
     justified=S+abs(MIN);  %��ֹ�����ֵС��0���¼������
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
         