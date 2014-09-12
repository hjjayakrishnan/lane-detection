clear all
close all


video=vision.VideoFileReader('goodroad.mp4');
videoPlay=vision.VideoPlayer;
frame=0;


while ~isDone(video)
    videoFrame=step(video);
    if frame>=1
        imwrite(videoFrame,'img.jpg');       

        image_raw=imread('img.jpg');
        %Convert the image to Grayscale
        image_gray=rgb2gray(image_raw);

        %Perform Median Filtering
        image_gray = medfilt2(image_gray);

        %Convert Grayscale image to Binary after analysing a suitable threshold
        threshold=200;
        image_gray(image_gray<threshold)=0;
        image_gray(image_gray>=threshold)=1; 
        image_binary=logical(image_gray);

        %Perform Median Filtering
        image_filtered=medfilt2(image_binary);

        %Edge Detection
        a=edge(image_filtered,'sobel');

        %Horizontal Edge Detection
        BW=edge(image_filtered,'sobel',(graythresh(image_gray)*0.3),'horizontal');

        %Hough Transform
        [H,theta,rho] = hough(BW); 

        % Finding the Hough peaks (number of peaks is set to 10)
        P = houghpeaks(H,2,'threshold',ceil(0.2*max(H(:))));
        x = theta(P(:,2));
        y = rho(P(:,1));

        %Fill the gaps of Edges and set the Minimum length of a line
        lines = houghlines(BW,theta,rho,P,'FillGap',170,'MinLength',50);


        figure(1),imshow(image_raw),hold on

        % iteration variable     
        p=2;
        flag=0;

        % Heuristic algorithm to get rid  of outliers
        for j=1:length(lines)

         dV =[lines(j).point1(1)-lines(j).point2(1) lines(j).point1(2)-lines(j).point2(2)];
         ang1=abs(atan2(dV(2),dV(1)))*180/pi;
         flagcount=1;
                    for k=j:length(lines)-1


                    dU =[lines(k+1).point1(1)-lines(k+1).point2(1) lines(k+1).point1(2)-lines(k+1).point2(2)];
                    ang(k)=abs((atan2(dV(2),dV(1))) - (atan2(dU(2),dU(1))))*180/pi;
                    ang2=abs(atan2(dU(2),dU(1)))*180/pi;

                            if(ang(k) >10&ang1<170&ang1>10&ang2<170&ang2>10)
                                p=p+1;               
                            else
                                flag(flagcount)=k+1;
                                flagcount=flagcount+1;
                            end

                    end
                    
                    
                    for m=1:length(flag)
                        
                         if flag==0
                             break;
                         else
                            lines(flag(m))=[];
                                for t=1:length(flag)
                                    flag(t)=flag(t)-1;
                                end;
                         end

                    end
                    flag=0;
                    
                    
                    if(j==length(lines))
                        break;
                     end

        end


        % Plotting the relevant lines
        for i=1:length(lines)
            xy = [lines(i).point1; lines(i).point2];
            figure(1),plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
            hold on
                if(length(lines)==2)
                    [interx, intery] = polyxpoly((lines(1).point1(1)-lines(1).point2(1)),(lines(1).point1(2)-lines(1).point2(2)),(lines(2).point1(1)-lines(2).point2(1)),(lines(2).point1(2)-lines(2).point2(2)));
                    plot(interx,intery,'x','LineWidth',4,'Color','green');    
                    hold on 
                end
        end


                frame=0;
            else 
                frame=frame+1;
                pause(0.001);
    end
end