function encode(s)
    enc=""
    prev=""
    count=1
    for ch in s
        if prev==ch
            count+=1
        else
            if count>1
                enc *=string(count)
            end
            enc*=string(prev)
            count=1
            prev=ch
        end
    end
    return count>1 ? enc*string(count)*string(prev) : enc*string(prev)
end



function decode(s)
    dec=""
    c=0
    for i in s
        if isdigit(i)
            c*=10
            c+=parse(Int,i)
        else
            if c==0
                c=1
            end
            dec*=(string(i)^c)
            c=0
        end
    end
    dec

end
