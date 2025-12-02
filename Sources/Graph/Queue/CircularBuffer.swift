/// A circular buffer (ring buffer) with fixed capacity
public struct CircularBuffer<Element>: Sendable where Element: Sendable {
    private var buffer: [Element?]
    private var readIndex: Int
    private var writeIndex: Int
    private var _count: Int

    /// The maximum number of elements the buffer can hold
    public let capacity: Int

    /// Creates a circular buffer with the specified capacity
    ///
    /// - Parameter capacity: The maximum number of elements
    /// - Throws: QueueError if capacity is less than 1
    public init(capacity: Int) throws {
        guard capacity > 0 else {
            throw StructError.queueError(.invalidCapacity)
        }

        self.capacity = capacity
        self.buffer = Array(repeating: nil, count: capacity)
        self.readIndex = 0
        self.writeIndex = 0
        self._count = 0
    }

    /// Returns true if the buffer is empty
    public var isEmpty: Bool {
        _count == 0
    }

    /// Returns true if the buffer is full
    public var isFull: Bool {
        _count == capacity
    }

    /// The number of elements in the buffer
    public var count: Int {
        _count
    }

    /// The number of available slots in the buffer
    public var availableSpace: Int {
        capacity - _count
    }

    /// Returns the element at the front without removing it
    public var front: Element? {
        guard !isEmpty else {
            return nil
        }
        return buffer[readIndex]
    }

    /// Returns the element at the back without removing it
    public var back: Element? {
        guard !isEmpty else {
            return nil
        }
        let index = (writeIndex - 1 + capacity) % capacity
        return buffer[index]
    }

    /// Writes an element to the buffer
    ///
    /// - Parameter element: The element to write
    /// - Returns: True if the element was written, false if the buffer is full
    @discardableResult
    public mutating func write(_ element: Element) -> Bool {
        guard !isFull else {
            return false
        }

        buffer[writeIndex] = element
        writeIndex = (writeIndex + 1) % capacity
        _count += 1
        return true
    }

    /// Reads and removes an element from the buffer
    ///
    /// - Returns: The element at the front, or nil if the buffer is empty
    @discardableResult
    public mutating func read() -> Element? {
        guard !isEmpty else {
            return nil
        }

        let element = buffer[readIndex]
        buffer[readIndex] = nil
        readIndex = (readIndex + 1) % capacity
        _count -= 1
        return element
    }

    /// Overwrites the oldest element if the buffer is full
    ///
    /// - Parameter element: The element to write
    public mutating func overwrite(_ element: Element) {
        if isFull {
            read()
        }
        write(element)
    }

    /// Returns all elements in the buffer in order
    public var elements: [Element] {
        guard !isEmpty else {
            return []
        }

        var result: [Element] = []
        var index = readIndex

        for _ in 0..<_count {
            if let element = buffer[index] {
                result.append(element)
            }
            index = (index + 1) % capacity
        }

        return result
    }

    /// Removes all elements from the buffer
    public mutating func clear() {
        buffer = Array(repeating: nil, count: capacity)
        readIndex = 0
        writeIndex = 0
        _count = 0
    }
}

extension CircularBuffer: CustomStringConvertible {
    public var description: String {
        "CircularBuffer(count: \(count), capacity: \(capacity))"
    }
}

extension CircularBuffer: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var buffer = self
        return AnyIterator {
            buffer.read()
        }
    }
}
