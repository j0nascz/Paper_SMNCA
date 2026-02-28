import os
import networkx as nx
import pandas as pd
import igraph as ig
import leidenalg as la
print(os.listdir())
path = "edges.tsv"
df = pd.read_csv("Data/Vir/component_1/edges.tsv", sep="\t")
df

G = nx.from_pandas_edgelist(
df,
source="q",
target="t",
edge_attr="bitscore", # keeps weight as an edge attribute
create_using=nx.Graph() # or nx.DiGraph() if directed
)

print(G.number_of_nodes(), G.number_of_edges())
print(list(G.edges(data=True))[:5])
#Louvain ausführen
louvain = nx.community.louvain_communities(G,weight="bitscore",resolution=1.0,
        threshold=1e-7,max_level=None,seed=42)
print("Louvain communities:", len(louvain))

g = ig.Graph.TupleList(
    df[["q", "t"]].itertuples(index=False, name=None),
    directed=False
)
g.es["weight"] = df["bitscore"].tolist()
#Leiden ausführen
Leiden = la.find_partition(g, la.ModularityVertexPartition, weights="weight")
print("Leiden communities:", len(Leiden))

#Louvain -> Communnity Vector
louvain_labels = {}

for community_id, community in enumerate(louvain):
    for node in community:
        louvain_labels[node] = community_id

louvain_vector = pd.Series(louvain_labels, name="community")

print(louvain_vector.head())

#Leiden -> Communnity Vector
leiden_labels = {}

for community_id, community in enumerate(Leiden):
    for node_index in community:
        node_name = g.vs[node_index]["name"]
        leiden_labels[node_name] = community_id

leiden_vector = pd.Series(leiden_labels, name="community")

print(leiden_vector.head())
