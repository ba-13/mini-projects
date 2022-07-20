function radius(x, y)
    return √(x^2 + y^2)
end

function score(x, y)
    points = 0
    if radius(x, y) > 10
        points += 0
    elseif radius(x, y) > 5
        points += 1
    elseif radius(x, y) > 1
        points += 5
    else
        points += 10
    end
    points
end

function bscore(x, y)
    r = hypot(x, y)
    r > 10 && return 0
    r > 5  && return 1
    r > 1  && return 5
    return 10
end