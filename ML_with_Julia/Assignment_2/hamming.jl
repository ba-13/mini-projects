"Your optional docstring here"
function distance(a::AbstractString, b::AbstractString)
    if length(a) != length(b) 
        throw(ArgumentError("Different lengths not allowed"))
    else
        hammingDistance = 0
        for i in range(1, length=length(a))
            if a[i] != b[i] 
                hammingDistance += 1
            end
        end
    end
hammingDistance
end

function bdistance(a::AbstractString, b::AbstractString)
    if length(a) != length(b)
        throw(ArgumentError("Different lengths not allowed"))
    end

    map(!=, a, b) |>
    sum
end
println(bdistance("ATSD", "SSDD"))