# testing evolving graph katz centrality on author network data
using EvolvingGraphs
import EzXML

jmlr_dict = Dict()

# load graph data at each year
# form evolving graph
eg= evolving_graph(String, Int)
for year in range(2001, 17)
    g = load_graphml("jmlr_$(year).graphml")
    add_graph!(eg, g, year)
end

rating = katz_centrality(eg)

sorted_authors = sort(rating, by = x -> x[2], rev = true)

println("Top 10 rating authors")
println(sorted_authors[1:10])

println("Button 10 rating authors")
println(sorted_authors[end-10:end])
