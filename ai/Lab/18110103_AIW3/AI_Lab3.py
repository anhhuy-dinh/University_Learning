import numpy as np
from queue import Queue, PriorityQueue, LifoQueue
from collections import defaultdict

def get_min(openset):
    node_min = openset[0]
    for node in openset:
        if node_min[-1] > node[-1]:
            node_min = node
    return node_min

class Graph:
    def __init__(self, vertices, heuristics, name_cities): 
        self.V = vertices 
        self.graph = defaultdict(list)
        self.heuristics = heuristics
        self.name_cities = name_cities
    
    def add_edge(self, src, dest, name, heuristic, weight):
        self.graph[src].append((dest, name, heuristic, weight))

    def display_graph(self): 
        for node in self.graph:
            print((node, self.name_cities[node]), "\t-->\t", self.graph[node])

    def GBFS(self, start, goal):
        frontier = PriorityQueue()
        root = (self.heuristics[start], start)
        frontier.put(root)
        explored = []
        father = {}
        path = [goal]
        while True:
            if frontier.empty():
                raise Exception("No way Exception")
            current_h, current_node = frontier.get()
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
            for vex in self.graph[current_node]:
                heur, node = vex[2], vex[0]
                if node not in explored:
                    frontier.put((heur, node))
                    if node not in father.keys():
                        father[node] = current_node
    
    def AStar(self, start, goal):
        openset = []
        openset_n = []
        root = (start, 0, 0, 0)
        openset.append(root)
        openset_n.append(root[0])
        closedset = []
        closedset_n = []
        father = {}
        path = [goal]
        while openset:
            if len(openset) == 0:
                raise Exception("No way Exception")
            current = get_min(openset)
            current_n, current_h, current_g, current_f = current
            openset.remove(current)
            openset_n.remove(current_n)
            closedset.append(current)
            closedset_n.append(current_n)
            if current_n == goal:
                key = goal
                while key in father.keys():
                    value = father.pop(key)
                    path.append(value)
                    key = value
                    if key == start:
                        break
                return path[::-1]
            for node in self.graph[current[0]]:
                node_n, node_h, node_g = node[0], node[2], node[-1]
                new_g = current_g + node_g
                new_f = new_g + node_h
                new_node = [node_n, node_h, new_g, new_f]
                if (node_n not in openset_n) & (node_n not in closedset_n) :
                    openset.append(new_node)
                    openset_n.append(node_n)
                    father[node_n] = current_n
                else:
                    if node_n in openset_n:
                        if new_g < openset[openset_n.index(node_n)][2]:
                            openset[openset_n.index(node_n)][2] = new_g
                            openset[openset_n.index(node_n)][3] = new_f
                            father[node_n] = current_n
                    else:
                        if node_n in closedset_n:
                            if new_g < closedset[closedset_n.index(node_n)][2]:
                                closedset[closedset_n.index(node_n)][2] = new_g
                                closedset[closedset_n.index(node_n)][3] = new_f
                                father[node_n] = current_n
        
    def display_solution(self, algorithm, start, goal):
        path = {'GBFS': self.GBFS(start, goal), 'ASTAR': self.AStar(start, goal)}
        print("Path from {} to {}: ".format(self.name_cities[start], self.name_cities[goal]))
        for node in path[algorithm]:
            if node != goal:
                print(self.name_cities[node], ' --> ', end='')
            else:
                print(self.name_cities[node])

def handle_input(name_file):
    with open(name_file, 'r') as f:
        vertices = int(f.readline())
        start, goal = [int(num) for num in f.readline().split(' ')]
        name_cities = [name for name in f.readline()[:-1].split('\t')]
        heuristic = [int(num) for num in f.readline().split('\t')]
        adj_matrix = [[int(num) for num in line.split('\t')] for line in f]
        f.close()
    return vertices, start, goal, name_cities, heuristic, adj_matrix

def create_graph(vertices, heuristic, name_cities, adj_matrix):
    temp_graph = Graph(vertices, heuristic, name_cities)
    for i in range(vertices):
        for j in range(vertices):
            if adj_matrix[i][j] != 0:
                temp_graph.add_edge(i, j, name_cities[j], heuristic[j], adj_matrix[i][j])
    return temp_graph

def main():
    vertices, start, goal, name_cities, heuristic, adj_matrix = handle_input('Input.txt')
    graph = create_graph(vertices, heuristic, name_cities, adj_matrix)
    print("\n\n")
    graph.display_graph()
    print("\n\n")
    print("*"*80)
    print(">> Using Greedy Best First Search")
    graph.display_solution(algorithm='GBFS', start=start, goal=goal)
    print("*"*80)
    print(">> Using A* Search")
    graph.display_solution(algorithm='ASTAR', start=start, goal=goal)
    print("*"*80)
    print("\n\n")
    

if __name__ == '__main__':
    main()