import os
import networkx as nx
import pandas as pd
import igraph as ig
import leidenalg as la
import matplotlib.pyplot as plt
import time

print(os.listdir())
path = "edges.tsv"
df = pd.read_csv("Data/Bac/component_1/edges.tsv", sep="\t")
df

G_bac = nx.from_pandas_edgelist(
df,
source="q",
target="t",
edge_attr="bitscore", # keeps weight as an edge attribute
create_using=nx.Graph() # or nx.DiGraph() if directed
)
#Degree distribution
degrees = [d for n, d in G_bac.degree()]

plt.hist(degrees, bins=50)
plt.xlabel("Degree")
plt.ylabel("Frequency")
plt.title("Degree Distribution of Bac Network")
plt.show()
pd.Series(degrees).to_csv("degrees_bac.csv", index=False)
print(G_bac.number_of_nodes(), G_bac.number_of_edges())
print(list(G_bac.edges(data=True))[:5])

#Execute Louvain
start = time.time()
louvain = nx.community.louvain_communities(G_bac,weight="bitscore",resolution=1.0,
        threshold=1e-7,max_level=None,seed=42)
end = time.time()
print("Louvain communities:", len(louvain))
print("Luvain runtime:", end - start, "seconds")

g = ig.Graph.TupleList(
    df[["q", "t"]].itertuples(index=False, name=None),
    directed=False
)
g.es["weight"] = df["bitscore"].tolist()

#Execute Leiden
start = time.time()
Leiden = la.find_partition(g, la.ModularityVertexPartition, weights="weight")
end = time.time()
print("Leiden communities:", len(Leiden))
print("Leiden runtime:", end - start, "seconds")

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

#Compute Modularity values
from networkx.algorithms.community.quality import modularity
Q_louvain = modularity(G_bac, louvain, weight="bitscore")
print("Louvain Modularity:", Q_louvain)
Q_leiden = Leiden.modularity
print("Leiden modularity:", round(Q_leiden, 4))


#Compute ARI between Louvain and Leiden
from sklearn.metrics import adjusted_rand_score 

nodes = sorted(G_bac.nodes())
louvain_labels_ordered = [louvain_labels[node] for node in nodes]
leiden_labels_ordered = [leiden_labels[node] for node in nodes]
ari = adjusted_rand_score(louvain_labels_ordered, leiden_labels_ordered)
print("Adjusted Rand Index between Louvain and Leiden:", ari)

