[isAnomaly,heart,breath]=findAnomaly(S,wwidth,lag); %�쳣���
[result_heart,result_breath,tmp_heart,tmp_breath]=dealAnomaly(S,isAnomaly);  %�쳣����
[AR,ARN,AALN,AER]=assessQuality(isAnomaly,S); %��������