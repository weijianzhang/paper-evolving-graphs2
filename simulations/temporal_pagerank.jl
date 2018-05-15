function block_google_matrix(g::IntAdjacencyList; alpha = 0.85, balance = 0.75)
    A = full(block_adjacency_matrix(g))
    A = balance * A + (1-balance) * A'
    N, N = size(A)
    p = ones(N)/N
    dangling_weights = p
    dangling_nodes = find(x->x==0, sum(A,2))

    for node in dangling_nodes
        A[node,:] = dangling_weights
    end
    A ./= sum(A,2)
    return alpha * A .+ (1- alpha) * p
end

function temporal_pagerank(g::AbstractEvolvingGraph)
    A = block_google_matrix(g)
    F = eigfact(A')
    println("F values $(F[:values])")
    return F[:vectors][:,1]
end
