clear all
close all

a = zeros(200,200);   a(50,50) = 1;



[m,n]=size(a);
a=double(a);

for i=1:m
    for j=1:n
        if(a(i,j)==1)
            a(i,j)=0;
        else
            a(i,j)=inf;
        end
    end
end


count=0;
b=zeros(m,n);
c=zeros(m,n);

% All Horizontal lines
for k=1:m

% from right to left
    for i=1:n
    countf=0;    
    for j=i :n-1
         if(a(k,i)>a(k,j+1))
            b(k,i)=countf+1;
            j=i;
            break;
         else
         countf=countf+1;
         end
    end
    end
% from left to right
    for i=n:-1:1
    countb=0;    
    for j=i:-1:2
        if(a(k,i)>a(k,j-1))
            c(k,i)=countb+1;
            j=i;
            break;
        else
            countb=countb+1;
        end
    end
    end
    % combining both L->R and R->L and choosing the relevant part
    for i=1:n
    if(b(k,i)&& c(k,i)~=0)
        if(b(k,i)>c(k,i))
            temp=b(k,i);
            b(k,i)=c(k,i);
            c(k,i)=temp;
        end
    else
        b(k,i)=b(k,i)+c(k,i);
    end
    end

end


d=zeros(m,n);
e=zeros(m,n);
%m=5;


% All vertical lines
for k=1:n
        % from bottom to top
        for i=1:m
        countf=0;    
        for j=i :m-1
             if(a(i,k)>a(j+1,k))
                d(i,k)=countf+1;
                j=i;
                break;
             else
             countf=countf+1;
             end
        end
        end
    % from top to bottom
        for i=m:-1:1
        countb=0;    
        for j=i:-1:2
            if(a(i,k)>a(j-1,k))
                e(i,k)=countb+1;
                j=i;
                break;
            else
                countb=countb+1;
            end
        end
        end
        % combining both B->T and T->B and choosing the relevant part
        for i=1:m
        if(d(i,k)&& e(i,k)~=0)
            if(d(i,k)>e(i,k))
                temp=d(i,k);
                d(i,k)=e(i,k);
                e(i,k)=temp;
            end
        else
            d(i,k)=d(i,k)+e(i,k);
        end
        end


end


% combinig both verical and horizontal distance transforms
for i=1:m
    for j=1:n
        if((b(i,j)==0 && d(i,j)~=0)||((b(i,j)~=0 && d(i,j)==0)))
            d(i,j)=d(i,j)+b(i,j);
        end
    end
end


% finding rows and columns of obstacles
p=1;
for i=1:m
    for j=1:n
        if(~a(i,j)&&d(i,j)==0)
            row(p)=i;
            column(p)=j;
            p=p+1;
        end
    end
end







for i=1:m
    for j=1:n
        
        if(a(i,j)==inf && d(i,j)==0)
            r_min=row(1);
            c_min=column(1);
            for k=1:length(row)

                if(abs(row(k)-i)<abs(r_min-i))  
                    r_min=row(k);
                end
            end

             for k=1:length(column)

                if(abs(column(k)-i)<abs(c_min-i))  
                    c_min=column(k);
                end
             end

             if(r_min<c_min)
                 min= r_min;
             else
                 min=c_min;
             end


                d(i,j)=d(i,min)+d(min,j);
        end

    end
end

imshow(uint8(d))


        
