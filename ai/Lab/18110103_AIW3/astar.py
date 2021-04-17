def aStar(start, goal, grid):
    openset = set()
    closedset = set()
    current = start
    openset.add(current)
    while openset:
        current = min(openset, key=lambda o:o.G + o.H)
        if current == goal:
            path = []
            while current.parent:
                path.append(current)
                current = current.parent
            path.append(current)
            return path[::-1]
        openset.remove(current)
        closedset.add(current)
        for node in children(current, grid):
            if node in closedset:
                continue
            if node in openset:
                new_g = current.G + current.move_cost(node)
                if node.G > new_g:
                    node.G = new_g
                    node.parent = current
                else:
                    node.G = current.G + current.move_cost(node)
                    node.H = manhattan(node, goal)
                    node.parent = current
                    openset.add(node)
    raise ValueError("No, Path Found")