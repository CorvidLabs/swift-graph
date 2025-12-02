/// A binary heap implementation supporting both min-heap and max-heap
public struct Heap<Element: Comparable>: Sendable where Element: Sendable {
    /// The type of heap
    public enum HeapType: Sendable {
        case minHeap
        case maxHeap
    }

    private var elements: [Element]
    private let type: HeapType

    /// Creates an empty heap
    ///
    /// - Parameter type: The type of heap (min or max)
    public init(type: HeapType = .minHeap) {
        self.elements = []
        self.type = type
    }

    /// Creates a heap from a sequence of elements
    ///
    /// - Parameters:
    ///   - elements: Elements to add to the heap
    ///   - type: The type of heap (min or max)
    public init<S: Sequence>(_ elements: S, type: HeapType = .minHeap) where S.Element == Element {
        self.elements = Array(elements)
        self.type = type
        buildHeap()
    }

    /// Returns true if the heap is empty
    public var isEmpty: Bool {
        elements.isEmpty
    }

    /// The number of elements in the heap
    public var count: Int {
        elements.count
    }

    /// Returns the top element without removing it
    public var peek: Element? {
        elements.first
    }

    /// Inserts an element into the heap
    ///
    /// - Parameter element: The element to insert
    public mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }

    /// Removes and returns the top element
    ///
    /// - Returns: The top element, or nil if the heap is empty
    @discardableResult
    public mutating func remove() -> Element? {
        guard !isEmpty else {
            return nil
        }

        if elements.count == 1 {
            return elements.removeLast()
        }

        let top = elements[0]
        elements[0] = elements.removeLast()
        siftDown(from: 0)
        return top
    }

    /// Removes all elements from the heap
    public mutating func removeAll() {
        elements.removeAll()
    }

    /// Replaces the top element with a new element
    ///
    /// - Parameter element: The new element
    /// - Returns: The previous top element, or nil if the heap was empty
    @discardableResult
    public mutating func replace(with element: Element) -> Element? {
        guard !isEmpty else {
            insert(element)
            return nil
        }

        let top = elements[0]
        elements[0] = element
        siftDown(from: 0)
        return top
    }

    // MARK: - Private Methods

    private mutating func buildHeap() {
        guard !elements.isEmpty else {
            return
        }

        for index in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
            siftDown(from: index)
        }
    }

    private mutating func siftUp(from index: Int) {
        var childIndex = index
        var parentIndex = self.parentIndex(of: childIndex)

        while childIndex > 0 && hasHigherPriority(elements[childIndex], than: elements[parentIndex]) {
            elements.swapAt(childIndex, parentIndex)
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }
    }

    private mutating func siftDown(from index: Int) {
        var parentIndex = index

        while true {
            let leftChildIndex = self.leftChildIndex(of: parentIndex)
            let rightChildIndex = self.rightChildIndex(of: parentIndex)
            var highestPriorityIndex = parentIndex

            if leftChildIndex < elements.count &&
                hasHigherPriority(elements[leftChildIndex], than: elements[highestPriorityIndex]) {
                highestPriorityIndex = leftChildIndex
            }

            if rightChildIndex < elements.count &&
                hasHigherPriority(elements[rightChildIndex], than: elements[highestPriorityIndex]) {
                highestPriorityIndex = rightChildIndex
            }

            if highestPriorityIndex == parentIndex {
                return
            }

            elements.swapAt(parentIndex, highestPriorityIndex)
            parentIndex = highestPriorityIndex
        }
    }

    private func hasHigherPriority(_ element1: Element, than element2: Element) -> Bool {
        switch type {
        case .minHeap:
            return element1 < element2
        case .maxHeap:
            return element1 > element2
        }
    }

    private func parentIndex(of index: Int) -> Int {
        (index - 1) / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        2 * index + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        2 * index + 2
    }
}

extension Heap: CustomStringConvertible {
    public var description: String {
        let typeString = type == .minHeap ? "MinHeap" : "MaxHeap"
        return "\(typeString)(count: \(count))"
    }
}

extension Heap: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var heap = self
        return AnyIterator {
            heap.remove()
        }
    }
}
