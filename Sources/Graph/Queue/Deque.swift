/// A double-ended queue (deque) that supports efficient insertion and removal from both ends
public struct Deque<Element>: Sendable where Element: Sendable {
    private var elements: [Element]

    /// Creates an empty deque
    public init() {
        self.elements = []
    }

    /// Creates a deque with the given elements
    ///
    /// - Parameter elements: Elements to add to the deque
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.elements = Array(elements)
    }

    /// Returns true if the deque is empty
    public var isEmpty: Bool {
        elements.isEmpty
    }

    /// The number of elements in the deque
    public var count: Int {
        elements.count
    }

    /// Returns the element at the front without removing it
    public var front: Element? {
        elements.first
    }

    /// Returns the element at the back without removing it
    public var back: Element? {
        elements.last
    }

    /// Adds an element to the front of the deque
    ///
    /// - Parameter element: The element to add
    public mutating func pushFront(_ element: Element) {
        elements.insert(element, at: 0)
    }

    /// Adds an element to the back of the deque
    ///
    /// - Parameter element: The element to add
    public mutating func pushBack(_ element: Element) {
        elements.append(element)
    }

    /// Removes and returns the element at the front
    ///
    /// - Returns: The front element, or nil if the deque is empty
    @discardableResult
    public mutating func popFront() -> Element? {
        guard !isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }

    /// Removes and returns the element at the back
    ///
    /// - Returns: The back element, or nil if the deque is empty
    @discardableResult
    public mutating func popBack() -> Element? {
        guard !isEmpty else {
            return nil
        }
        return elements.removeLast()
    }

    /// Returns the element at the specified index
    ///
    /// - Parameter index: The index of the element
    /// - Returns: The element at the index
    public subscript(index: Int) -> Element {
        get {
            elements[index]
        }
        set {
            elements[index] = newValue
        }
    }

    /// Removes all elements from the deque
    public mutating func removeAll() {
        elements.removeAll()
    }
}

extension Deque: Collection {
    public var startIndex: Int {
        elements.startIndex
    }

    public var endIndex: Int {
        elements.endIndex
    }

    public func index(after i: Int) -> Int {
        elements.index(after: i)
    }
}

extension Deque: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        elements.index(before: i)
    }
}

extension Deque: RandomAccessCollection {}

extension Deque: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension Deque: CustomStringConvertible {
    public var description: String {
        "Deque(\(elements))"
    }
}

extension Deque: Equatable where Element: Equatable {
    public static func == (lhs: Deque<Element>, rhs: Deque<Element>) -> Bool {
        lhs.elements == rhs.elements
    }
}

extension Deque: Hashable where Element: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(elements)
    }
}
