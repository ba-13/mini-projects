function to_rna(dna::AbstractString)
    ref = Dict{Char,Char}('A' => 'U', 'T' => 'A', 'C' => 'G', 'G' => 'C')
    rna = ""
    for ch in dna
        if ch ∉ keys(ref) throw(ErrorException("Not a valid DNA nucleotide"))
        else
            rna *= ref[ch]
        end
    end
    rna
end

function to_rna(c::Char)
    c == 'C' && return 'G'
    c == 'G' && return 'C'
    c == 'T' && return 'A'
    c == 'A' && return 'U'
    throw(ErrorException("Unknown nucleotide: $c"))
end
  
function bto_rna(dna::AbstractString)
    map(to_rna, dna)
end