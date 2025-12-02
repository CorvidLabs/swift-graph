/// Errors that can occur when working with data structures
public enum StructError: Error, Sendable {
    /// The requested element was not found
    case elementNotFound

    /// The structure is empty
    case emptyStructure

    /// An invalid index was provided
    case indexOutOfBounds

    /// The operation is not supported
    case unsupportedOperation

    /// A graph-specific error occurred
    case graphError(GraphError)

    /// A tree-specific error occurred
    case treeError(TreeError)

    /// A queue-specific error occurred
    case queueError(QueueError)
}

/// Errors specific to graph operations
public enum GraphError: Error, Sendable {
    /// The vertex does not exist in the graph
    case vertexNotFound

    /// The edge already exists
    case duplicateEdge

    /// No path exists between vertices
    case noPathExists

    /// The graph contains a cycle
    case cycleDetected
}

/// Errors specific to tree operations
public enum TreeError: Error, Sendable {
    /// The tree is empty
    case emptyTree

    /// The node does not exist
    case nodeNotFound

    /// Invalid tree operation
    case invalidOperation
}

/// Errors specific to queue operations
public enum QueueError: Error, Sendable {
    /// The queue is empty
    case emptyQueue

    /// The queue is full
    case queueFull

    /// Invalid capacity
    case invalidCapacity
}

extension StructError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .elementNotFound:
            return "Element not found"
        case .emptyStructure:
            return "Structure is empty"
        case .indexOutOfBounds:
            return "Index out of bounds"
        case .unsupportedOperation:
            return "Operation not supported"
        case .graphError(let error):
            return "Graph error: \(error)"
        case .treeError(let error):
            return "Tree error: \(error)"
        case .queueError(let error):
            return "Queue error: \(error)"
        }
    }
}
