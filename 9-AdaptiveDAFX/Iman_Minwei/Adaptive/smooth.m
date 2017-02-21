function out = smooth (a)
    for i=1:length(a)-2
        if (a(i)-a(i+1)>2) && (a(i+2)-a(i+1))>2
            a(i+1)=a(i);
        end
        if (a(i+1)-a(i))>2 && (a(i+1)-a(i+2))>2
            a(i+1) =a(i);
        end
    end
    out=a;
end
      