\section{Community Detection Methods}

In this section, we will explore the community detection methods that form
the core of this study.

\subsection{Edge Betweenness}

The edge betweenness method, introduced by Girvan and Newman (2002),
was developed to overcome the shortcomings of traditional community detection methods such as 
the hierarchical clustering approach. The hierarchical clustering method focuses on 
constructing a measure that indicates which edges are most central to communities.
Using these measures, it constructs communities by adding the strongest edges
to an initially empty graph. However, this method has several drawbacks,
such as relying on a subjective choice of similarity measure.
Furthermore, because it tries to build communities by adding edges,
early mistakes caused by noise in the data cannot be corrected later on.

The edge betweenness method, on the other hand, removes weak edges from the 
original graph instead of adding edges.
To identify weak edges in a graph, Girvan and Newman generalized Freeman's betweenness centrality
to edges.

\textcite{newmanandgirvan2002} state that if a network contains communities
or groups that are only loosely connected by a few intergroup edges, then all shortest paths
between different communities must pass through one of these few edges. Thus, the edges connecting
communities will have high edge betweenness. By removing these edges, we separate groups
from one another and thereby reveal the underlying community structure of the graph.

The algorithm they propose can be summarized as follows:

\begin{enumerate}
  \item Compute the edge betweenness for all edges in the network.
  \item Remove the edge with the highest edge betweenness.
  \item Recalculate the edge betweenness for all edges affected by the removal.
  \item Repeat from step 2 until no edges remain.
\end{enumerate}

The iteration ends when no edges remain; therefore, in practice, we must
decide when to stop the algorithm. This can be done by evaluating the modularity of
the network after each iteration and stopping when the modularity is maximized.

This algorithm is computationally expensive because we must
recalculate edge betweenness after each iteration, making the algorithm
run in worst-case time $O(m^2 n)$, where $m$ is the number of edges and $n$ is 
the number of nodes in the graph.

It may be tempting to calculate the betweenness of all edges only once and then remove them in order
of decreasing betweenness. However, this approach does not work well,
because if two communities are connected by more than one edge, there is 
no guarantee that all of these edges will have high betweenness. By
recalculating betweenness after the removal of each edge, we can ensure that 
at least one of the remaining edges between two communities will always have high betweenness.

\subsection{Louvain Method}

The Louvain algorithm, introduced by Blondel et al. (2008), is a popular method
for community detection in large networks. The core idea is to group nodes 
so that connections inside communities are denser than expected at random.
Louvain achieves this through greedy local optimization of the modularity measure, 
combined with a hierarchical approach.

The algorithm consists of two phases that are repeated iteratively until no
further improvement in modularity is possible:

\begin{enumerate}
  \item \textbf{Modularity Optimization:} 
  \begin{itemize}
    \item Initially, each node is assigned to its own community. 
    \item For each node $i$, we consider moving it to the community of each neighbor.
    \item The change in modularity $\Delta Q$ is calculated for each possible move, 
    and the node is moved to the community that results in the highest increase in modularity.
    $\Delta Q$ is given by the formula: 
    \[
    \Delta Q = Q(i \in C) - Q(i \in A)
    \]
    where $Q(i \in C)$ is the modularity of the network if node $i$ is moved to community $C$, 
    and $Q(i \in A)$ is the modularity if node $i$ remains in its current community $A$.
    The formula for calculating modularity is given by: 
    \[
    Q = \frac{1}{2m} \sum_{ij}\left[A_{ij} - \gamma \frac{k_i k_j}{2m}\right]\delta(c_i, c_j)
    \]
    where $A_{ij}$ is the adjacency matrix of the graph, $k_i$ and $k_j$ are the degrees of nodes $i$ and $j$,
    $m$ is the total number of edges in the graph, $c_i$ and $c_j$ are the communities of nodes $i$ and $j$, 
    and $\delta(c_i, c_j)$ is the Kronecker delta function, which equals 1 if $c_i = c_j$ and 0 otherwise.
    $\gamma$ is the resolution parameter that allows control over the size of the detected communities.
    If $\gamma = 1$, we obtain the standard modularity. If $\gamma < 1$, larger communities are detected,
    and if $\gamma > 1$, smaller communities are detected.
  \end{itemize}

  \item \textbf{Community Aggregation:} 
  \begin{itemize}
    \item After no further individual node movements can increase modularity, we create a 
    new network in which each community is treated as a single node,
          also known as a supernode.
    \item Edges between supernodes are replaced by weighted edges,
          where the weight of the edge between two supernodes is the sum of the weights 
          of the edges between the nodes in the corresponding communities.
    \item Edges within the same community are represented as self-loops.
  \end{itemize}
\end{enumerate}

In the figure below, we can see a visualization of the Louvain method.

\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.4\textwidth]{Pictures/community_detection_methods/Louvain.png}
  \caption{Visual representation of the Louvain method for community detection. Adapted from~\cite{Louvain}.}
  \label{fig:louvain}
\end{figure}

The hierarchical nature of the Louvain method allows it to capture community structure at multiple scales, and it is computationally efficient, 
with a time complexity of $O(n \log n)$ in practice, making it suitable for large networks.

However, there are several notable limitations to the Louvain method. First, it does not guarantee that the detected communities
are internally connected. In practice, a community may consist of multiple disconnected components.
Furthermore, the algorithm may converge to a local maximum of modularity, as it only ensures that no single node move can further increase 
modularity.

These shortcomings motivated Traag, Waltman, and van Eck (2019) to introduce the Leiden algorithm, which is discussed in the following section.