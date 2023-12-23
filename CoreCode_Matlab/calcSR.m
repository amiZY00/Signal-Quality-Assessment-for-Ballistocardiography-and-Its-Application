function [fshift,SRshift,Smap,Ashift]=calcSR(S)
%calculate the Saliency map of the input timeseies, and also Spectral
%Residual map will be returned
%Param: fshift:centralized frequencies
%Param: SRshift:centralized Spectral Residual
%Param: Smap:Saliency Map
n=length(S);
FFT=fft(S);
FFTshift=fftshift(FFT);
Amap=abs(FFT);
Ashift=abs(FFTshift);
Lmap=log(Amap);
Lshift=log(Ashift);
Phase=angle(FFT);
SpectralResidual=Lmap-imfilter(Lmap,fspecial('average',51),'replicate');
SRshift=Lshift-imfilter(Lshift,fspecial('average',51),'replicate');
Smap=abs(ifft(exp(SpectralResidual+1i*Phase))).^2;
fshift=(-n/2:n/2-1)*50/n;
end