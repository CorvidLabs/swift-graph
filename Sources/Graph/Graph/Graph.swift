/// A generic graph data structure supporting both directed and undirected graphs with optional weighted edges
public struct Graph<Vertex: Hashable>: Sendable where Vertex: Sendable {
    /// The type of graph
    public enum GraphType: Sendable {
        case directed
        case undirected
    }

    /// The type of graph (directed or undirected)
    public let type: GraphType

    /// Adjacency list representation of the graph
    internal var adjacencyList: [Vertex: [Edge<Vertex>]]

    /// Creates a new graph
    ///
    /// - Parameter type: The type of graph (directed or undirected)
    public init(type: GraphType = .directed) {
        self.type = type
        self.adjacencyList = [:]
    }

    /// All vertices in the graph
    public var vertices: [Vertex] {
        Array(adjacencyList.keys)
    }

    /// All edges in the graph
    public var edges: [Edge<Vertex>] {
        adjacencyList.values.flatMap { $0 }
    }

    /// The number of vertices in the graph
    public var vertexCount: Int {
        adjacencyList.count
    }

    /// The number of edges in the graph
    public var edgeCount: Int {
        switch type {
        case .directed:
            return edges.count
        case .undirected:
            return edges.count / 2
        }
    }

    /// Adds a vertex to the graph
    ///
    /// - Parameter vertex: The vertex to add
    public mutating func addVertex(_ vertex: Vertex) {
        adjacencyList[vertex] = adjacencyList[vertex] ?? []
    }

    /// Adds an edge to the graph
    ///
    /// - Parameters:
    ///   - source: The source vertex
    ///   - destination: The destination vertex
    ///   - weight: Optional weight of the edge
    /// - Throws: GraphError if vertices don't exist
    public mutating func addEdge(
        from source: Vertex,
        to destination: Vertex,
        weight: Double? = nil
    ) throws {
        // Ensure both vertices exist
        addVertex(source)
        addVertex(destination)

        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencyList[source]?.append(edge)

        // For undirected graphs, add reverse edge
        if type == .undirected {
            let reverseEdge = Edge(source: destination, destination: source, weight: weight)
            adjacencyList[destination]?.append(reverseEdge)
        }
    }

    /// Returns the edges from a given vertex
    ///
    /// - Parameter vertex: The source vertex
    /// - Returns: Array of edges from the vertex
    public func edges(from vertex: Vertex) -> [Edge<Vertex>] {
        adjacencyList[vertex] ?? []
    }

    /// Returns the weight of an edge between two vertices
    ///
    /// - Parameters:
    ///   - source: The source vertex
    ///   - destination: The destination vertex
    /// - Returns: The weight of the edge, or nil if no edge exists
    public func weight(from source: Vertex, to destination: Vertex) -> Double? {
        adjacencyList[source]?
            .first(where: { $0.destination == destination })?
            .weight
    }

    /// Checks if there is an edge between two vertices
    ///
    /// - Parameters:
    ///   - source: The source vertex
    ///   - destination: The destination vertex
    /// - Returns: True if an edge exists, false otherwise
    public func hasEdge(from source: Vertex, to destination: Vertex) -> Bool {
        adjacencyList[source]?.contains(where: { $0.destination == destination }) ?? false
    }

    /// Returns the neighbors of a given vertex
    ///
    /// - Parameter vertex: The vertex
    /// - Returns: Array of neighboring vertices
    public func neighbors(of vertex: Vertex) -> [Vertex] {
        edges(from: vertex).map(\.destination)
    }

    /// Removes a vertex from the graph
    ///
    /// - Parameter vertex: The vertex to remove
    public mutating func removeVertex(_ vertex: Vertex) {
        adjacencyList.removeValue(forKey: vertex)

        // Remove all edges pointing to this vertex
        for key in adjacencyList.keys {
            adjacencyList[key]?.removeAll { $0.destination == vertex }
        }
    }

    /// Removes an edge from the graph
    ///
    /// - Parameters:
    ///   - source: The source vertex
    ///   - destination: The destination vertex
    public mutating func removeEdge(from source: Vertex, to destination: Vertex) {
        adjacencyList[source]?.removeAll { $0.destination == destination }

        // For undirected graphs, remove reverse edge
        if type == .undirected {
            adjacencyList[destination]?.removeAll { $0.destination == source }
        }
    }

    /// Removes all vertices and edges from the graph
    public mutating func removeAll() {
        adjacencyList.removeAll()
    }
}

extension Graph: CustomStringConvertible {
    public var description: String {
        let typeString = type == .directed ? "Directed" : "Undirected"
        let vertexString = vertices.map(String.init(describing:)).joined(separator: ", ")
        return "\(typeString) Graph with vertices: [\(vertexString)]"
    }
}
