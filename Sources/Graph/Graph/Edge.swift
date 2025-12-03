/// Represents an edge in a graph connecting two vertices
public struct Edge<Vertex: Hashable>: Sendable where Vertex: Sendable {
    /// The source vertex
    public let source: Vertex

    /// The destination vertex
    public let destination: Vertex

    /// The weight of the edge (nil for unweighted graphs)
    public let weight: Double?

    /**
     Creates a new edge

     - Parameters:
       - source: The source vertex
       - destination: The destination vertex
       - weight: Optional weight of the edge
     */
    public init(
        source: Vertex,
        destination: Vertex,
        weight: Double? = nil
    ) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension Edge: Equatable where Vertex: Equatable {
    public static func == (lhs: Edge<Vertex>, rhs: Edge<Vertex>) -> Bool {
        lhs.source == rhs.source &&
        lhs.destination == rhs.destination &&
        lhs.weight == rhs.weight
    }
}

extension Edge: Hashable where Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
        hasher.combine(weight)
    }
}

extension Edge: CustomStringConvertible {
    public var description: String {
        if let weight = weight {
            return "\(source) -> \(destination) (weight: \(weight))"
        } else {
            return "\(source) -> \(destination)"
        }
    }
}
