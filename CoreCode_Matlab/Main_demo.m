[isAnomaly,heart,breath]=findAnomaly(S,wwidth,lag); %异常检测
[result_heart,result_breath,tmp_heart,tmp_breath]=dealAnomaly(S,isAnomaly);  %异常处理
[AR,ARN,AALN,AER]=assessQuality(isAnomaly,S); %质量评估