import numpy as np
import math
from queue import PriorityQueue
from collections import defaultdict

def handle_input(name_file):
    with open(name_file, 'r') as f:
        number_polygons, start_x, start_y, goal_x, goal_y = [float(num) for num in f.readline().split('\t')]
        number_polygons = int(number_polygons)
        start_point = (start_x, start_y, 'S')
        goal_point = (goal_x, goal_y, 'G')
        polygons = []
        number_vertices = []
        for i in range(number_polygons):
            polygon_values = [float(num) for num in f.readline().split('\t')]
            number_vertices.append(int(polygon_values[0]))
            polygon = []
            for j in range(1, len(polygon_values) - 1, 2):
                vertice = (polygon_values[j], polygon_values[j+1], i+1)
                polygon.append(vertice)
            polygons.append(polygon)
        f.close()
    return number_polygons, start_point, goal_point, polygons, number_vertices

def is_different_side(edge, point_1, point_2):
    x1 = edge[0][0]
    y1 = edge[0][1]
    x2 = edge[1][0]
    y2 = edge[1][1]
    d1 = (point_1[0] - x1)*(y2 - y1) - (point_1[1] - y1)*(x2 - x1)
    d2 = (point_2[0] - x1)*(y2 - y1) - (point_2[1] - y1)*(x2 - x1)
    return d1*d2 < 0

def distance(point1, point2):
    return np.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)

class Graph:
    def __init__(self, number_polygons, polygons, number_vertices):
        self.number_polygons = number_polygons
        self.graph = defaultdict(list)
        self.weights = defaultdict(list)
        self.polygons = polygons
        self.number_vertices = number_vertices

    def get_all_edges(self):
        edges = []
        for i in range(self.number_polygons):
            pol = self.polygons[i]
            num_ver = self.number_vertices[i]
            for j in range(num_ver):
                edge = [pol[j % num_ver], pol[(j + 1) % num_ver]]
                edges.append(edge)
        return edges

    def get_all_points(self, start_point, goal_point):
        points = [start_point, goal_point]
        for polygon in self.polygons:
            for i in range(len(polygon)):
                points.append(polygon[i])
        return points

    def get_adjacent_point(self):
        adjacent_points = defaultdict(list)
        edges = self.get_all_edges()
        for edge in edges:
            point1 = edge[0]
            point2 = edge[1]
            adjacent_points[point1].append(point2)
            adjacent_points[point2].append(point1)
        return adjacent_points


    def successor(self, start_point, goal_point):
        edges = self.get_all_edges()
        points = self.get_all_points(start_point, goal_point)
        adjacent_points = self.get_adjacent_point()
        viewless_points = defaultdict(list)
        for cur_point in points:
            for edge in edges:
                for point in points:
                    if (point == cur_point) or (point in edge):
                        continue
                    if (point[2] == cur_point[2]) and (point not in adjacent_points[cur_point]):
                        if point not in viewless_points[cur_point]:
                            viewless_points[cur_point].append(point)
                    else:
                        edge1 = (cur_point, edge[0])
                        edge2 = (cur_point, edge[1])
                        if (is_different_side(edge1, edge[1], point) == False\
                            and is_different_side(edge2, edge[0], point) == False\
                            and is_different_side(edge, cur_point, point) == True):
                            if point in self.graph[cur_point]:
                                self.graph[cur_point].remove(point)
                            if point not in viewless_points[cur_point]:
                                viewless_points[cur_point].append(point)
                        else:
                            if point not in viewless_points[cur_point]:
                                if point not in self.graph[cur_point]:    
                                    self.graph[cur_point].append(point)

    def get_weight(self):
        for cur_point in self.graph.keys():
            for point in self.graph[cur_point]:
                self.weights[cur_point].append(round(distance(cur_point, point), 2))

    def display(self):
        des = defaultdict(list)
        for point in self.graph:
            for i in range(len(self.graph[point])):
                des[point].append((self.graph[point][i], self.weights[point][i]))
            print(point, "\t-->\t", (des[point]))

    def find_shortest_path(self, start_point, goal_point):
        frontier = PriorityQueue()
        frontier.put((0, [start_point]))
        explored = set()
        while frontier:
            if frontier.empty():
                raise Exception("No way Exception")
            current_w, path = frontier.get()
            current_point = path[len(path)-1]
            if current_point not in explored:
                explored.add(current_point)
                if current_point == goal_point:
                    return round(current_w, 2), path
            for i in range(len(self.graph[current_point])):
                point = self.graph[current_point][i]
                weight = self.weights[current_point][i]
                if point not in explored:
                    temp = path[:]
                    temp.append(point)
                    frontier.put((weight + current_w, temp))
 

    def display_shortest_path(self, start_point, goal_point):
        distance, shortest_path = self.find_shortest_path(start_point, goal_point)
        print("The shortest path from", start_point, " to ", goal_point, ":")
        print("Distance: ", distance)
        for point in shortest_path:
            if point != goal_point:
                print(point, ' --> ', end='')
            else:
                print(point)

def create_graph(number_polygons, polygons, number_vertices, start_point, goal_point):
    temp_graph = Graph(number_polygons, polygons, number_vertices)
    temp_graph.successor(start_point, goal_point)
    temp_graph.get_weight()
    return temp_graph

def main():
    number_polygons, start_point, goal_point, polygons, \
                     number_vertices = handle_input('input.txt')
    graph = create_graph(number_polygons, polygons, number_vertices, start_point, goal_point)
    print("\n\n")
    graph.display_shortest_path(start_point, goal_point)
    print("\n\n")

if __name__ == '__main__':
    main()

    