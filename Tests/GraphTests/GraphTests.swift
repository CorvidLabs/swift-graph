import Testing
@testable import Graph

@Suite("Graph Tests")
struct GraphTests {
    @Test("Graph initialization")
    func testGraphInitialization() {
        let directedGraph = Graph<Int>(type: .directed)
        let undirectedGraph = Graph<Int>(type: .undirected)

        #expect(directedGraph.type == .directed)
        #expect(undirectedGraph.type == .undirected)
        #expect(directedGraph.vertexCount == 0)
        #expect(directedGraph.edgeCount == 0)
    }

    @Test("Add vertices and edges")
    func testAddVerticesAndEdges() throws {
        var graph = Graph<Int>(type: .directed)

        graph.addVertex(1)
        graph.addVertex(2)
        #expect(graph.vertexCount == 2)

        try graph.addEdge(from: 1, to: 2, weight: 5.0)
        #expect(graph.edgeCount == 1)
        #expect(graph.hasEdge(from: 1, to: 2))
        #expect(graph.weight(from: 1, to: 2) == 5.0)
    }

    @Test("Undirected graph edges")
    func testUndirectedGraphEdges() throws {
        var graph = Graph<String>(type: .undirected)

        try graph.addEdge(from: "A", to: "B", weight: 10.0)

        #expect(graph.hasEdge(from: "A", to: "B"))
        #expect(graph.hasEdge(from: "B", to: "A"))
        #expect(graph.edgeCount == 1) // Undirected counts once
    }

    @Test("Graph neighbors")
    func testGraphNeighbors() throws {
        var graph = Graph<Int>(type: .directed)

        try graph.addEdge(from: 1, to: 2)
        try graph.addEdge(from: 1, to: 3)
        try graph.addEdge(from: 1, to: 4)

        let neighbors = graph.neighbors(of: 1)
        #expect(neighbors.count == 3)
        #expect(neighbors.contains(2))
        #expect(neighbors.contains(3))
        #expect(neighbors.contains(4))
    }

    @Test("Breadth-first search")
    func testBreadthFirstSearch() throws {
        var graph = Graph<Int>(type: .directed)

        try graph.addEdge(from: 1, to: 2)
        try graph.addEdge(from: 1, to: 3)
        try graph.addEdge(from: 2, to: 4)
        try graph.addEdge(from: 3, to: 4)

        let bfsResult = graph.breadthFirstSearch(from: 1)
        #expect(bfsResult.first == 1)
        #expect(bfsResult.contains(2))
        #expect(bfsResult.contains(3))
        #expect(bfsResult.contains(4))
    }

    @Test("Depth-first search")
    func testDepthFirstSearch() throws {
        var graph = Graph<Int>(type: .directed)

        try graph.addEdge(from: 1, to: 2)
        try graph.addEdge(from: 1, to: 3)
        try graph.addEdge(from: 2, to: 4)

        let dfsResult = graph.depthFirstSearch(from: 1)
        #expect(dfsResult.first == 1)
        #expect(dfsResult.count == 4)
    }

    @Test("Shortest path - Dijkstra")
    func testShortestPath() throws {
        var graph = Graph<String>(type: .directed)

        try graph.addEdge(from: "A", to: "B", weight: 4.0)
        try graph.addEdge(from: "A", to: "C", weight: 2.0)
        try graph.addEdge(from: "C", to: "B", weight: 1.0)
        try graph.addEdge(from: "B", to: "D", weight: 5.0)
        try graph.addEdge(from: "C", to: "D", weight: 8.0)

        let result = try graph.shortestPath(from: "A", to: "D")
        #expect(result != nil)
        #expect(result?.distance == 8.0) // A -> C -> B -> D
    }

    @Test("Cycle detection")
    func testCycleDetection() throws {
        var acyclicGraph = Graph<Int>(type: .directed)
        try acyclicGraph.addEdge(from: 1, to: 2)
        try acyclicGraph.addEdge(from: 2, to: 3)
        #expect(!acyclicGraph.hasCycle())

        var cyclicGraph = Graph<Int>(type: .directed)
        try cyclicGraph.addEdge(from: 1, to: 2)
        try cyclicGraph.addEdge(from: 2, to: 3)
        try cyclicGraph.addEdge(from: 3, to: 1)
        #expect(cyclicGraph.hasCycle())
    }

    @Test("Remove vertex")
    func testRemoveVertex() throws {
        var graph = Graph<Int>(type: .directed)

        try graph.addEdge(from: 1, to: 2)
        try graph.addEdge(from: 2, to: 3)

        graph.removeVertex(2)
        #expect(graph.vertexCount == 2)
        #expect(!graph.hasEdge(from: 1, to: 2))
    }

    @Test("Remove edge")
    func testRemoveEdge() throws {
        var graph = Graph<Int>(type: .directed)

        try graph.addEdge(from: 1, to: 2)
        #expect(graph.hasEdge(from: 1, to: 2))

        graph.removeEdge(from: 1, to: 2)
        #expect(!graph.hasEdge(from: 1, to: 2))
    }
}
