/// Algorithms for graph traversal and analysis
extension Graph {
    /**
     Performs breadth-first search starting from a given vertex

     - Parameter start: The starting vertex
     - Returns: Array of vertices in BFS order
     */
    public func breadthFirstSearch(from start: Vertex) -> [Vertex] {
        guard adjacencyList[start] != nil else {
            return []
        }

        var visited: Set<Vertex> = []
        var queue: [Vertex] = [start]
        var result: [Vertex] = []

        while !queue.isEmpty {
            let vertex = queue.removeFirst()

            guard !visited.contains(vertex) else {
                continue
            }

            visited.insert(vertex)
            result.append(vertex)

            let neighborVertices = neighbors(of: vertex)
            queue.append(contentsOf: neighborVertices.filter { !visited.contains($0) })
        }

        return result
    }

    /**
     Performs depth-first search starting from a given vertex

     - Parameter start: The starting vertex
     - Returns: Array of vertices in DFS order
     */
    public func depthFirstSearch(from start: Vertex) -> [Vertex] {
        guard adjacencyList[start] != nil else {
            return []
        }

        var visited: Set<Vertex> = []
        var result: [Vertex] = []

        func dfs(_ vertex: Vertex) {
            guard !visited.contains(vertex) else {
                return
            }

            visited.insert(vertex)
            result.append(vertex)

            for neighbor in neighbors(of: vertex) {
                dfs(neighbor)
            }
        }

        dfs(start)
        return result
    }

    /**
     Finds the shortest path between two vertices using Dijkstra's algorithm

     - Parameters:
       - start: The starting vertex
       - end: The destination vertex
     - Returns: A tuple containing the path and total distance, or nil if no path exists
     - Throws: GraphError if vertices don't exist
     */
    public func shortestPath(
        from start: Vertex,
        to end: Vertex
    ) throws -> (path: [Vertex], distance: Double)? {
        guard adjacencyList[start] != nil else {
            throw StructError.graphError(.vertexNotFound)
        }
        guard adjacencyList[end] != nil else {
            throw StructError.graphError(.vertexNotFound)
        }

        var distances: [Vertex: Double] = [start: 0]
        var previous: [Vertex: Vertex] = [:]
        var unvisited = Set(vertices)

        while !unvisited.isEmpty {
            // Find unvisited vertex with minimum distance
            guard let current = unvisited
                .compactMap({ vertex -> (Vertex, Double)? in
                    guard let distance = distances[vertex] else { return nil }
                    return (vertex, distance)
                })
                .min(by: { $0.1 < $1.1 })?
                .0
            else {
                break
            }

            unvisited.remove(current)

            if current == end {
                break
            }

            guard let currentDistance = distances[current] else {
                continue
            }

            // Update distances to neighbors
            for edge in edges(from: current) {
                let neighbor = edge.destination
                let edgeWeight = edge.weight ?? 1.0
                let newDistance = currentDistance + edgeWeight

                if newDistance < (distances[neighbor] ?? .infinity) {
                    distances[neighbor] = newDistance
                    previous[neighbor] = current
                }
            }
        }

        // Reconstruct path
        guard let finalDistance = distances[end] else {
            return nil
        }

        var path: [Vertex] = []
        var current: Vertex? = end

        while let vertex = current {
            path.insert(vertex, at: 0)
            current = previous[vertex]
        }

        guard path.first == start else {
            return nil
        }

        return (path: path, distance: finalDistance)
    }

    /**
     Detects if the graph contains a cycle

     - Returns: True if the graph contains a cycle, false otherwise
     */
    public func hasCycle() -> Bool {
        var visited: Set<Vertex> = []
        var recursionStack: Set<Vertex> = []

        func detectCycle(from vertex: Vertex) -> Bool {
            visited.insert(vertex)
            recursionStack.insert(vertex)

            for neighbor in neighbors(of: vertex) {
                if !visited.contains(neighbor) {
                    if detectCycle(from: neighbor) {
                        return true
                    }
                } else if recursionStack.contains(neighbor) {
                    return true
                }
            }

            recursionStack.remove(vertex)
            return false
        }

        for vertex in vertices {
            if !visited.contains(vertex) {
                if detectCycle(from: vertex) {
                    return true
                }
            }
        }

        return false
    }

    /**
     Performs topological sort on a directed acyclic graph

     - Returns: Array of vertices in topological order
     - Throws: GraphError if the graph contains a cycle
     */
    public func topologicalSort() throws -> [Vertex] {
        guard type == .directed else {
            throw StructError.graphError(.invalidOperation)
        }

        if hasCycle() {
            throw StructError.graphError(.cycleDetected)
        }

        var visited: Set<Vertex> = []
        var stack: [Vertex] = []

        func visit(_ vertex: Vertex) {
            guard !visited.contains(vertex) else {
                return
            }

            visited.insert(vertex)

            for neighbor in neighbors(of: vertex) {
                visit(neighbor)
            }

            stack.insert(vertex, at: 0)
        }

        for vertex in vertices {
            visit(vertex)
        }

        return stack
    }
}

extension GraphError {
    static let invalidOperation = GraphError.cycleDetected
}
