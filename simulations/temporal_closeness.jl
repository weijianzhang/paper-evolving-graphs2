function temporal_closeness(g::Union{AbstractEvolvingGraph, IntAdjacencyList}, start::Union{TimeNode,Tuple{Int,Int}})
    v = start
    level = Dict(v => 0)
    i = 1
    fronter = [v]
    while length(fronter) > 0
        next = []
        for u in fronter
            for v in forward_neighbors(g, u)
                if !(v in keys(level))
                    td = temporal_distance(start, u)
                    level[v] = i + td
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end

    total_scores = sum(values(level))
    return total_scores > 0. ? (length(level) - 1)/total_scores : 0.
end
