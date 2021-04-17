import numpy as np
from queue import LifoQueue

class MCGraph:
    def __init__(self, state = (3, 3, 1), num_of_moves = 0, parent = None):
        self.state = state
        self.num_of_moves = num_of_moves
        self.parent = parent
    
    def __str__(self):
        return str(self.state)
    
    def is_goal_state(self):
        return self.state == (0, 0, 0)

    def is_valid(self):
        missionaries = self.state[0]
        cannibals = self.state[1]
        boat = self.state[2]
        if missionaries < 0 or missionaries > 3:
            return False
        if cannibals < 0 or cannibals > 3:
            return False
        if boat < 0 or boat > 1:
            return False
        return True
    
    def is_killed(self):
        missionaries = self.state[0]
        cannibals = self.state[1]
        if missionaries > 0 and missionaries < cannibals:
            return True
        # Check for the other side
        if missionaries > cannibals and missionaries < 3:
            return True
        return False

    def generate_child(self):
        children = []
        op = -1 # Subtract
        if self.state[2] == 0:
            op = 1 # Add
        miss, cans, boat_side = self.state
        for mis in range(3):
            for can in range(3):
                new_state_vars = (miss + op*mis, cans + op*can, boat_side + op)
                new_state = MCGraph(new_state_vars, self.num_of_moves + 1, self)
                if mis + can >= 1 and mis + can <= 2 and new_state.is_valid():
                    children.append(new_state)
        return children
    
    def find_solution_dfs(self):
        root = self
        frontier = LifoQueue()
        frontier.put(root)
        explored = []
        solutions = []
        while True:
            if frontier.empty():
                break
            current_state = frontier.get()
            childs = current_state.generate_child()
            for child in childs[::-1]:
                child_state = child.state
                if child_state not in explored:
                    if child.is_killed():
                        continue
                    elif child.is_goal_state():
                        solutions.append(child)
                    frontier.put(child)
                    explored.append(child_state)      
        return solutions

def display_solution(mc_graph):
    solutions = mc_graph.find_solution_dfs()
    if len(solutions):
        current_state = solutions[0]
        while current_state:
            if current_state.parent:
                print(current_state, " <-- ", end='')
            else:
                print(current_state)
            current_state = current_state.parent
    else:
        raise Exception("No solution Exception")

def main():
    mc_problem = MCGraph((3,3,1))
    display_solution(mc_problem)

if __name__ == "__main__":
    main()