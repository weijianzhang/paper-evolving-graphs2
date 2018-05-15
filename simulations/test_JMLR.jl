# testing evolving graph katz centrality on author network data
using EvolvingGraphs
using EvolvingGraphs.Centrality
import EzXML

jmlr_dict = Dict()

# load graph data at each year
# form evolving graph
g = EvolvingGraph{Node{String}, Int}()

for year in range(2001, 17)
    sg = load_graphml("jmlr_$(year).graphml")
    add_graph!(g, sg, year)
end

rating = katz(g, 0.1, 0.01; mode = :receive)

sorted_authors = sort(rating, by = x -> x[2], rev = true)

println("Top 10 rating authors")
println(sorted_authors[1:10])

println("Button 10 rating authors")
println(sorted_authors[end-10:end])
