/// A priority queue implemented using a binary heap
public struct PriorityQueue<Element: Comparable>: Sendable where Element: Sendable {
    private var heap: Heap<Element>

    /// Creates an empty priority queue
    ///
    /// - Parameter isMinQueue: If true, creates a min-priority queue; otherwise, creates a max-priority queue
    public init(isMinQueue: Bool = true) {
        self.heap = Heap(type: isMinQueue ? .minHeap : .maxHeap)
    }

    /// Creates a priority queue from a sequence of elements
    ///
    /// - Parameters:
    ///   - elements: Elements to add to the queue
    ///   - isMinQueue: If true, creates a min-priority queue; otherwise, creates a max-priority queue
    public init<S: Sequence>(_ elements: S, isMinQueue: Bool = true) where S.Element == Element {
        self.heap = Heap(elements, type: isMinQueue ? .minHeap : .maxHeap)
    }

    /// Returns true if the queue is empty
    public var isEmpty: Bool {
        heap.isEmpty
    }

    /// The number of elements in the queue
    public var count: Int {
        heap.count
    }

    /// Returns the highest priority element without removing it
    public var peek: Element? {
        heap.peek
    }

    /// Inserts an element into the queue
    ///
    /// - Parameter element: The element to insert
    public mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }

    /// Removes and returns the highest priority element
    ///
    /// - Returns: The highest priority element, or nil if the queue is empty
    @discardableResult
    public mutating func dequeue() -> Element? {
        heap.remove()
    }

    /// Removes all elements from the queue
    public mutating func removeAll() {
        heap.removeAll()
    }
}

extension PriorityQueue: CustomStringConvertible {
    public var description: String {
        "PriorityQueue(count: \(count))"
    }
}

extension PriorityQueue: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var queue = self
        return AnyIterator {
            queue.dequeue()
        }
    }
}
