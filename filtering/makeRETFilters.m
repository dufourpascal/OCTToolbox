function F=makeRETFilters
% Returns the LML filter bank of size 49x49x48 in F. To convolve an
% image I with the filter bank you can either use the matlab function
% conv2, i.e. responses(:,:,i)=conv2(I,F(:,:,i),'valid'), or use the
% Fourier transform.

  SUP=29;                 % Support of the largest filter (must be odd)
  SCALES=[0.25, 0.5, 1, 2];  % Sigma_{x} for the oriented filters
  NF = 2*length(SCALES);
  F=zeros(SUP,SUP,NF);
  
  count=1;
  for s=1:length(SCALES)
      F(:,:,count)=makeBendFilter(SCALES(s), 1, SUP);
      F(:,:,count+1)=makeBendFilter(SCALES(s), 2, SUP);      
      count=count+2;
  end;

  
%   [fx fy fz] = size(F);
%   for z = 1:fz
%     subplot(4,2,z), imshow(F(:,:,z), []);
%   end
  
return

function f=makeBendFilter(scale,ord,sup)

ptsX = zeros(sup);
ptsY = zeros(sup);
ptsY2 = zeros(sup);


s2p = sqrt(2*pi);
varGauss = 0.075;
vg = 1/3;
denom=2*vg^2;
        
for x = 1:sup
    for y = 1:sup
        xt = x/sup*pi;
        xg = -1 + 2*x/sup;
        yg =  1*y/sup;
        yt = -1 -0.5/scale + y/sup/scale;
      

        
        ptsY(y,x) = exp(-xg^2/denom)/s2p*vg;
        ptsY2(y,x) = exp(-yg^2/denom)/s2p*vg;
                
        ptsX(y,x) = (-yt - sin(xt));
        
        
        p = ptsX(y,x)*scale;        
        mx2 = p^2;
        tv2 = 2*varGauss^2;
        
        switch ord
            case 1, ptsX(y,x) = exp(- mx2/tv2) * (p) / (s2p * varGauss^3);
            case 2, ptsX(y,x) = exp(- mx2/tv2) * (- varGauss^2 + p^2) / (s2p * varGauss^5);
        end
        
%         subplot(2,2,1), imshow(ptsX,[])
%         pause(0.1)
        
    end
end

%normalize
ptsX = ptsX-mean(mean(ptsX)); ptsX = ptsX/sum(sum(abs(ptsX)));

f = normalise(ptsX .* ptsY .* ptsY2);
%   f = normalise(f);
return

 
function f=normalise(f), f=f-mean(f(:)); f=f/sum(abs(f(:))); return
