module nerpzsgf

using MathProgBase
import Clp

greet() = print("Hello World!")

function notIstrat(game::Array{Tuple{T, T}, 2} where {T<:Real})
    (nrows, ncols) = size(game)
    a = ones(nrows+1, ncols+1)
    b = zeros(nrows+1)
    c = zeros(ncols+1)
    c[1] = 1
    l = zeros(ncols+1)
    l[1] = -Inf
    u = ones(ncols+1)
    u[1] = Inf
    sense = Array{Char}(undef, nrows+1)
    for i = 1:size(a,1)-1
        a[i,1] = -1
        sense[i] = '<'
        for j = 2:size(a,2)
            a[i,j] = game[i,j-1][1]
        end
    end
    a[size(a,1), 1] = 0
    sense[end] = '='
    b[end] = 1
    sol = linprog(c, a, sense, b, l, u, Clp.ClpSolver())
    return sol
end
    
function Istrat(game::Array{Tuple{T, T}, 2} where {T<:Real})
    transgame = transposeGame(game)
    sol = notIstrat(transgame)

end

function transposeGame(game::Array{Tuple{T, T}, 2} where {T<:Real})
    tran = Array{Tuple{Real, Real}}(undef, size(game, 2), size(game,1))
    for i in 1:size(game,1)
        for j in 1:size(game,2)
            tran[j, i] = game[i, j]
        end
    end
    tran
end

end # module
