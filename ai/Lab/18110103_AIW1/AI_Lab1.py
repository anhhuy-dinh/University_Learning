import numpy as np
from queue import Queue, PriorityQueue, LifoQueue
from collections import defaultdict

class Graph:
    def __init__(self, vertices): 
        self.V = vertices 
        self.graph = defaultdict(list)
  
    def add_edge(self, src, dest): 
        self.graph[src].append(dest)
    
    def add_edge_weight(self, src, dest, weight):
        self.graph[src].append((weight, dest))

    def display_graph(self): 
        for node in self.graph:
            print(node, "\t-->\t", self.graph[node])

    def bfs(self, start, goal):
        frontier = Queue()
        frontier.put(start)
        explored = []
        father = {}
        path = [goal]
        while True:
            if frontier.empty():
                raise Exception("No way Exception")
            current_node = frontier.get()
            explored.append(current_node)
            if current_node == goal:
                key = goal
                while key in father.keys():
                    value = father.pop(key)
                    path.append(value)
                    key = value
                    if key == start:
                        break
                path.reverse()
                return path
            if current_node not in self.graph:
                continue
            for node in self.graph[current_node]:
                if node not in explored:
                    frontier.put(node)
                    if node not in father.keys():
                        father[node] = current_node

    def dfs(self, start, goal):
        frontier = LifoQueue()
        frontier.put(start)
        explored = []
        father = {}
        path = [goal]
        while True:
            if frontier.empty():
                raise Exception("No way Exception")
            current_node = frontier.get()
            explored.append(current_node)
            if current_node == goal:
                key = goal
                while key in father.keys():
                    value = father.pop(key)
                    path.append(value)
                    key = value
                    if key == start:
                        break
                path.reverse()
                return path
            if current_node not in self.graph:
                continue
            for node in self.graph[current_node]:
                if node not in explored:
                    frontier.put(node)
                    if node not in father.keys():
                        father[node] = current_node

    def ucs(self, start, goal):
        frontier = PriorityQueue()
        frontier.put((0, start))
        explored = []
        father = {}
        path = [goal]
        while True:
            if frontier.empty():
                raise Exception("No way Exception")
            current_w, current_node = frontier.get()
            explored.append(current_node)
            if current_node == goal:
                key = goal
                while key in father.keys():
                    value = father.pop(key)
                    path.append(value)
                    key = value
                    if key == start:
                        break
                path.reverse()
                return current_w, path
            if current_node not in self.graph:
                continue
            for vex in self.graph[current_node]:
                weight, node = vex
                if node not in explored:
                    frontier.put((current_w + weight, node))
                    if node not in father.keys():
                        father[node] = current_node

def handle_input(name_file):
    with open(name_file, 'r') as f:
        vertices = int(f.readline())
        start, goal = [int(num) for num in f.readline().split(' ')]
        adj_matrix = [[int(num) for num in line.split(' ')] for line in f]
        f.close()
    return vertices, start, goal, adj_matrix

def create_graph(vertices, adj_matrix):
    temp_graph = Graph(vertices)
    for i in range(vertices):
        for j in range(vertices):
            if adj_matrix[i][j] != 0:
                temp_graph.add_edge(i, j)
    return temp_graph

def create_graph_weight(vertices, adj_matrix):
    temp_graph = Graph(vertices)
    for i in range(vertices):
        for j in range(vertices):
            if adj_matrix[i][j] != 0:
                temp_graph.add_edge_weight(i, j, adj_matrix[i][j])
    return temp_graph

def main():
    vertices, start, goal, adj_matrix = handle_input('Input.txt')
    ver_ucs, start_ucs, goal_ucs, adj_matrix_ucs = handle_input('InputUCS.txt')
    graph = create_graph(vertices, adj_matrix)
    path_bfs = graph.bfs(start - 1, goal - 1)
    path_dfs = graph.dfs(start - 1, goal - 1)
    graph_ucs = create_graph_weight(ver_ucs, adj_matrix_ucs)
    graph_ucs.display_graph()
    # cost_ucs, path_ucs = graph_ucs.ucs(start_ucs - 1, goal_ucs - 1)
    # print("Path from {} to {} using BFS: {}".format(start - 1, goal - 1, path_bfs))
    # print("Path from {} to {} using DFS: {}".format(start - 1, goal - 1, path_dfs))
    # print("The shortest path from {} to {} using UCS: {} - cost: {}".format(start_ucs - 1, goal_ucs - 1, path_ucs, cost_ucs))

if __name__ == '__main__':
    main()