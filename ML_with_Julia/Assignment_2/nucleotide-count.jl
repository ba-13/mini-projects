"""
    count_nucleotides(strand)

The frequency of each nucleotide within `strand` as a dictionary.

Invalid strands raise a `DomainError`.

"""
function count_nucleotides(strand)
    A = T = C = G = 0
    for i in strand
        if i == 'A'
            A += 1
        elseif i == 'T'
            T += 1
        elseif i == 'C'
            C += 1
        elseif i == 'G'
            G += 1
        else
            throw(DomainError(i))
        end
    end
    return Dict('A' => A, 'C' => C, 'G' => G, 'T' => T)
end

"""
A better solution
"""
function bcount_nucleotides(strand::AbstractString)
    cnt = Dict{Char,UInt}('A' => 0, 'C' => 0, 'G' => 0, 'T' => 0)
    for ch in strand
        ch ∉ keys(cnt) && throw(DomainError(ch, "Unknown nucleotide"))
        cnt[ch] += 1
    end
    cnt
end

