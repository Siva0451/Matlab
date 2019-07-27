function ImageScaling(image,width,height,s)
     
    im = imread(image);
    img=cast(im,'int16'); 
    [in_width,in_height,d] = size(img);
    wscale = in_width/ width;
    hscale = in_height/height;
    
    for n = 1: height
        l = n * hscale;
       
        y1 = floor(l);
        y2 = ceil(l);
        
        if y1== 0
            y1 = 1;
        end
        if y2 > in_height
           y2= in_height;
         end
        
        
        for m = 1: width
            k= m* wscale;
 
            x1 = floor(k);
            x0 = floor(k) - 1;
            x2 = ceil(k);
            x3 = ceil(k) +1;
            
            if x3 > in_width
                x3= in_width;
            end
            if x2 > in_width
                x2= in_width;
            end
            
            if x0<=0 
                x0 = 1;
            end
            if x1== 0
                x1=1;
            end
            
            T1 = img(x0,y1,:);
            T2 = img(x1,y1,:);
            T3 = img(x2,y1,:);
            T4 = img(x3,y1,:);
            
            B1 = img(x0,y2,:);
            B2 = img(x1,y2,:);
            B3 = img(x2,y2,:);
            B4 = img(x3,y2,:);
            
            C1 = (s*T2) - T1 - T3 - B2;
            C2 = (s*T3) - T2 - T4 - B3;
            C3 = (s*B2) - B1 - B3 - T2;
            C4 = (s*B3) -B2  - B4 - T3;
            
            ns = s-3;

            NT2 = C1/ns;
            NT3 = C2/ns;
            NB2 = C3/ns;
            NB3 = C4/ns;
            
            
            A = abs( T3 - T1) - abs(T4 - T2);
            
            if A > 0
                FT2 = T2;
                FB2 = B2;
                FT3 = NT3;
                FB3 = NB3;
                
            elseif A < 0
                FT2 = NT2;
                FB2 = NB2;
                FT3 = T3;
                FB3 = B3;
            else
                FT2 = NT2;
                FB2 = NB2;
                FT3 = NT3;
                FB3 = NB3;
            end

               dx = k - x1;
               dy = l - y1;
               im_zoom(m,n,:)= ((1-dx)*(1-dy)*FT2) + (dx*(1-dy)*FT3) + ((1-dx)*dy*FB2) + (dx*dy*FB3) ;
        end     
    end
    imshow(cast(im_zoom,'uint8'));
    imwrite(cast(im_zoom,'uint8'),'Lenna_zoom15015011.jpg');
end
    