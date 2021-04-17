import numpy as np
from queue import Queue, PriorityQueue, LifoQueue
from collections import defaultdict

class Graph:
    def __init__(self, vertices): 
        self.V = vertices 
        self.graph = defaultdict(list)
    
    def add_edge(self, src, dest, weight):
        self.graph[src].append((dest, weight))

    def display_graph(self): 
        for node in self.graph:
            print(node, "\t-->\t", self.graph[node])

    # A utility function to find set of an element i
    # (uses path compression technique)
    def find(self, parent, i):
        if parent[i] == i:
            return i
        return self.find(parent, parent[i])

    # A function that does union of two sets of x and y
    # (uses union by rank)
    def union(self, parent, rank, x, y):
        xroot = self.find(parent, x)
        yroot = self.find(parent, y)
 
        # Attach smaller rank tree under root of
        # high rank tree (Union by Rank)
        if rank[xroot] < rank[yroot]:
            parent[xroot] = yroot
        elif rank[xroot] > rank[yroot]:
            parent[yroot] = xroot
 
        # If ranks are same, then make one as root
        # and increment its rank by one
        else:
            parent[yroot] = xroot
            rank[xroot] += 1

    def MST_Kruskal(self):
        temp_graph = []
        for cur_node in self.graph:
            current_adj_nodes = self.graph[cur_node]
            for i in range(len(current_adj_nodes)):
                node, weight = current_adj_nodes[i]
                temp_graph.append((cur_node, node, weight))

        result = []  # This will store the resultant MST
        # An index variable, used for sorted edges
        i = 0
        # An index variable, used for result[]
        e = 0
 
        # Step 1:  Sort all the edges in 
        # non-decreasing order of their
        # weight.  If we are not allowed to change the
        # given graph, we can create a copy of graph
        sorted_graph = sorted(temp_graph, key=lambda item: item[2])
 
        parent = []
        rank = []
 
        # Create V subsets with single elements
        for node in range(self.V):
            parent.append(node)
            rank.append(0)
 
        # Number of edges to be taken is equal to V-1
        while e < self.V - 1:
 
            # Step 2: Pick the smallest edge and increment
            # the index for next iteration
            u, v, w = sorted_graph[i]
            i = i + 1
            x = self.find(parent, u)
            y = self.find(parent, v)
 
            # If including this edge does't
            #  cause cycle, include it in result 
            #  and increment the indexof result 
            # for next edge
            if x != y:
                e = e + 1
                result.append([u, v, w])
                self.union(parent, rank, x, y)
            # Else discard the edge
 
        minimumCost = 0
        print("Edges in the constructed MST using Kruskal")
        for u, v, weight in result:
            minimumCost += weight
            print("%d -- %d (%d)" % (u, v, weight))
        print("Minimum Spanning Tree - minimum total cost: " , minimumCost)

def handle_input(name_file):
    with open(name_file, 'r') as f:
        vertices = int(f.readline())
        adj_matrix = [[int(num) for num in line.split('\t')] for line in f]
        f.close()
    return vertices, adj_matrix

def create_graph(vertices, adj_matrix):
    temp_graph = Graph(vertices)
    for i in range(vertices):
        for j in range(vertices):
            if adj_matrix[i][j] != 0:
                temp_graph.add_edge(i, j, adj_matrix[i][j])
    return temp_graph

def main():
    vertices, adj_matrix = handle_input('input.txt')
    graph = create_graph(vertices, adj_matrix)
    print("\n\n")
    graph.display_graph()
    print("\n\n")
    graph.MST_Kruskal()
    

if __name__ == '__main__':
    main()