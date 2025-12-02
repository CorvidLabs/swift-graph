# swift-graph

A comprehensive collection of high-performance data structures implemented in pure Swift 6 with strict concurrency support.

## Features

- Pure Swift 6 implementation
- All types are `Sendable` for safe concurrent usage
- No external dependencies (except swift-docc-plugin for documentation)
- Protocol-oriented design with modern Swift patterns
- Comprehensive test coverage (75+ tests)
- Full platform support: iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, visionOS 1+

## Data Structures

### Graph

**Graph.swift** - Generic graph with directed/undirected support and weighted edges
- Adjacency list representation
- Support for both directed and undirected graphs
- Optional edge weights
- Efficient neighbor lookups

**Edge.swift** - Edge type with optional weight
- Hashable and Equatable conformance
- Type-safe vertex connections

**GraphAlgorithms.swift** - Common graph algorithms
- Breadth-first search (BFS)
- Depth-first search (DFS)
- Shortest path (Dijkstra's algorithm)
- Cycle detection
- Topological sort

### Tree

**BinaryTree.swift** - Generic binary tree
- Enum-based implementation for value semantics
- Tree traversals: in-order, pre-order, post-order, level-order
- Map transformation support
- Height and count computations

**BinarySearchTree.swift** - Self-balancing BST
- Insert, search, and delete operations
- In-order traversal yields sorted sequence
- Min/max element queries
- Efficient O(log n) average case performance

**Heap.swift** - Min/max heap implementation
- Configurable as min-heap or max-heap
- Efficient insert and remove operations (O(log n))
- Peek top element in O(1)
- Replace operation for efficient pop-and-push
- Sequence conformance for sorted iteration

### Trie

**Trie.swift** - Prefix tree for efficient string operations
- Generic over any `Hashable` element type
- String-specific extensions for common use cases
- Prefix searching
- Auto-complete functionality
- Space-efficient storage for shared prefixes

**TrieNode.swift** - Node type for trie structure
- Efficient child management
- Termination marking for valid sequences

### Queue

**Deque.swift** - Double-ended queue
- Efficient operations at both ends
- Collection, BidirectionalCollection, and RandomAccessCollection conformance
- Array literal initialization
- Subscript access

**PriorityQueue.swift** - Heap-based priority queue
- Min or max priority queue configuration
- Efficient enqueue/dequeue operations
- Built on top of Heap for optimal performance
- Sequence conformance

**CircularBuffer.swift** - Fixed-capacity ring buffer
- Constant-time write and read operations
- Overflow handling with optional overwrite
- Space-efficient implementation
- Useful for streaming data and buffering

### BloomFilter

**BloomFilter.swift** - Probabilistic set membership testing
- Space-efficient membership testing
- Configurable false positive rate
- No false negatives
- Union and intersection operations
- Automatic optimal sizing based on expected count

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/swift-graph.git", from: "0.1.0")
]
```

Then add `Graph` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Graph"]
)
```

## Usage Examples

### Graph

```swift
import Graph

var graph = Graph<String>(type: .directed)

try graph.addEdge(from: "A", to: "B", weight: 4.0)
try graph.addEdge(from: "A", to: "C", weight: 2.0)

let bfsResult = graph.breadthFirstSearch(from: "A")
let shortestPath = try graph.shortestPath(from: "A", to: "C")
```

### Binary Search Tree

```swift
import Graph

var bst = BinarySearchTree([5, 3, 7, 1, 9])

bst.insert(4)
print(bst.contains(4)) // true
print(bst.min()) // 1
print(bst.inOrder()) // [1, 3, 4, 5, 7, 9]

bst.remove(3)
```

### Heap

```swift
import Graph

var minHeap = Heap([5, 3, 7, 1, 9], type: .minHeap)

print(minHeap.peek) // 1
print(minHeap.remove()) // 1
print(minHeap.remove()) // 3
```

### Trie

```swift
import Graph

let trie = Trie(["cat", "car", "card", "dog"])

print(trie.contains("cat")) // true
print(trie.hasPrefix("car")) // true

let matches = trie.strings(withPrefix: "car")
print(matches) // ["car", "card"]
```

### Deque

```swift
import Graph

var deque = Deque<Int>()

deque.pushBack(1)
deque.pushBack(2)
deque.pushFront(0)

print(deque.popFront()) // 0
print(deque.popBack()) // 2
```

### Priority Queue

```swift
import Graph

var queue = PriorityQueue([5, 3, 7, 1], isMinQueue: true)

print(queue.dequeue()) // 1
print(queue.dequeue()) // 3
```

### Circular Buffer

```swift
import Graph

var buffer = try CircularBuffer<Int>(capacity: 3)

buffer.write(1)
buffer.write(2)
buffer.write(3)

print(buffer.read()) // 1
buffer.write(4) // Writes to position freed by read
```

### Bloom Filter

```swift
import Graph

var filter = BloomFilter<String>(expectedCount: 1000, falsePositiveRate: 0.01)

filter.insert("apple")
filter.insert("banana")

print(filter.contains("apple")) // true
print(filter.contains("grape")) // false (probably)
```

## Error Handling

The package defines comprehensive error types:

- `StructError` - General errors across all structures
- `GraphError` - Graph-specific errors (vertex not found, cycle detected, etc.)
- `TreeError` - Tree-specific errors
- `QueueError` - Queue-specific errors (empty queue, invalid capacity, etc.)

## Testing

Run the test suite:

```bash
swift test
```

The package includes 75+ comprehensive tests covering all data structures and their operations.

## Performance Characteristics

| Structure | Insert | Search | Delete | Space |
|-----------|--------|--------|--------|-------|
| Graph | O(1) | O(V+E) | O(E) | O(V+E) |
| BST | O(log n)* | O(log n)* | O(log n)* | O(n) |
| Heap | O(log n) | O(n) | O(log n) | O(n) |
| Trie | O(m) | O(m) | O(m) | O(n*m) |
| Deque | O(1)** | O(1) | O(1)** | O(n) |
| Priority Queue | O(log n) | O(1) | O(log n) | O(n) |
| Circular Buffer | O(1) | O(1) | O(1) | O(k) |
| Bloom Filter | O(k) | O(k) | N/A | O(m) |

\* Average case for balanced tree
\** Amortized complexity
m = string length, n = number of elements, k = hash functions, V = vertices, E = edges

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please ensure all tests pass and add tests for new functionality.

## Requirements

- Swift 6.0+
- Platform support: iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, visionOS 1+
