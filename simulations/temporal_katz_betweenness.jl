function temporal_distance(v1::TimeNode, v2::TimeNode, beta::Real = 0.1)
    return beta* abs(node_timestamp(v1) - node_timestamp(v2))
end
function temporal_distance(v1::Tuple{Int,Int}, v2::Tuple{Int,Int}, beta::Real = 0.1)
    return beta * abs(v1[2] - v2[2])
end


function temporal_katz(g::IntAdjacencyList, start::Tuple{Int,Int}; alpha = 0.1, k = 10)
    score = 0.
    v = start
    fronter = [v]
    level = 0
    while level < k
        next = []
        for u in fronter
            fn = forward_neighbors(g, u)
            fn = sample(fn, min(100, length(fn)), replace=false)
            println("number of neighbors $(length(fn))")
            for v in fn
                push!(next, v)
                td = temporal_distance(start, u)
                d = td + level

                score += alpha^d
            end
        end
        fronter = next
        level += 1
    end
    return score
end




function temporal_katz(g::AbstractEvolvingGraph, start_node::TimeNode, end_node::TimeNode; alpha = 0.2, k = 10)
    score = 0.
    v = start_node
    fronter = [v]
    level = 0
    while level < k
        next = []
        for u in fronter
            fn = forward
            for v in forward_neighbors(g, u)
                push!(next, v)
                if u == end_node
                    td = temporal_distance(start_node, u)
                    d = td + level
                    score += alpha^d
                end
            end
        end
        fronter = next
        level += 1
    end
    return score
end


function temporal_resolvent_betweenness(g1::EvolvingGraph, g2::EvolvingGraph, v::TimeNode; alpha = 0.2, k = 10)
    r = 0.
    ns = active_nodes(g1)
    for i in ns
        for j in ns
            if i != j && i != v && j != v

                score1 = temporal_katz(g1, i, j, alpha = alpha, k = k)
                score2 = temporal_katz(g2, i, j, alpha = alpha, k = k)
#                 println("From node $i to node $j")
#                 println("score1 $score1 and score2 $score2")
                r += score1 == 0.0 ? 0 : (score1 - score2)/score1
            end
        end
    end
    return r
end
