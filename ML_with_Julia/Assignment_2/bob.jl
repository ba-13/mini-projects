# submit
function bob(stimulus)
    sent = strip(stimulus)
    ans = "Whatever."

    if length(sent) == 0
        ans = "Fine. Be that way!"
    elseif endswith(sent, '?')
        if isupper(sent)
            ans = "Calm down, I know what I'm doing!"
        else
            ans = "Sure."
        end
    elseif isupper(sent)
        ans = "Whoa, chill out!"
    end

    return ans

end

function isupper(sent)
    res = false
    for c ∈ sent
        if isletter(c)
            if isuppercase(c)
                res = true
            else
                res = false
                break
            end
        end
    end
    return res
end