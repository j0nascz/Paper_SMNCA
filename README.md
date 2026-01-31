Modularity-based analysis (Bac vs Vir)

Data
Bac/   → one bacterial network  
Vir/   → one viral network

Goal

Identify and compare community structure using different modularity-based methods, and sensitivity analysis on the parameters.

Compare parameters effect for the 2 networks:

number of communities
community sizes
modularity values

Import one network

Python

import networkx as nx

G = nx.read_edgelist(
    "Vir/network.tsv",
    delimiter="\t",
    nodetype=str
)

print(nx.number_connected_components(G))

library(igraph)

edges <- read.table("Vir/network.tsv", sep="\t", stringsAsFactors=FALSE)
g <- graph_from_data_frame(edges, directed=FALSE)

Seminar project:

Introduction
   -Introduce the paper, and the project
Methods 
   -Discussion of the paper, and similar papers (with formulas)
Results
   -Discussion of the data, with summary statistics
   -Application of the methods on the data
   -Interpretation of the results
Conclusion

6 Credits -> 15/20 pages
9 Credits -> 20/30 pages
