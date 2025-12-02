import Testing
@testable import Graph

@Suite("Deque Tests")
struct DequeTests {
    @Test("Empty deque")
    func testEmptyDeque() {
        let deque = Deque<Int>()
        #expect(deque.isEmpty)
        #expect(deque.count == 0)
        #expect(deque.front == nil)
        #expect(deque.back == nil)
    }

    @Test("Push front")
    func testPushFront() {
        var deque = Deque<Int>()
        deque.pushFront(1)
        deque.pushFront(2)
        deque.pushFront(3)

        #expect(deque.count == 3)
        #expect(deque.front == 3)
        #expect(deque.back == 1)
    }

    @Test("Push back")
    func testPushBack() {
        var deque = Deque<Int>()
        deque.pushBack(1)
        deque.pushBack(2)
        deque.pushBack(3)

        #expect(deque.count == 3)
        #expect(deque.front == 1)
        #expect(deque.back == 3)
    }

    @Test("Pop front")
    func testPopFront() {
        var deque = Deque([1, 2, 3])

        #expect(deque.popFront() == 1)
        #expect(deque.popFront() == 2)
        #expect(deque.count == 1)
    }

    @Test("Pop back")
    func testPopBack() {
        var deque = Deque([1, 2, 3])

        #expect(deque.popBack() == 3)
        #expect(deque.popBack() == 2)
        #expect(deque.count == 1)
    }

    @Test("Subscript access")
    func testSubscript() {
        var deque = Deque([1, 2, 3, 4])

        #expect(deque[0] == 1)
        #expect(deque[3] == 4)

        deque[1] = 10
        #expect(deque[1] == 10)
    }

    @Test("Collection conformance")
    func testCollectionConformance() {
        let deque = Deque([1, 2, 3, 4, 5])
        let doubled = deque.map { $0 * 2 }

        #expect(doubled == [2, 4, 6, 8, 10])
    }

    @Test("Array literal initialization")
    func testArrayLiteral() {
        let deque: Deque<Int> = [1, 2, 3]
        #expect(deque.count == 3)
        #expect(deque.front == 1)
    }
}

@Suite("Priority Queue Tests")
struct PriorityQueueTests {
    @Test("Min priority queue")
    func testMinPriorityQueue() {
        var queue = PriorityQueue<Int>(isMinQueue: true)
        queue.enqueue(5)
        queue.enqueue(3)
        queue.enqueue(7)
        queue.enqueue(1)

        #expect(queue.peek == 1)
        #expect(queue.dequeue() == 1)
        #expect(queue.dequeue() == 3)
        #expect(queue.count == 2)
    }

    @Test("Max priority queue")
    func testMaxPriorityQueue() {
        var queue = PriorityQueue<Int>(isMinQueue: false)
        queue.enqueue(5)
        queue.enqueue(3)
        queue.enqueue(7)
        queue.enqueue(1)

        #expect(queue.peek == 7)
        #expect(queue.dequeue() == 7)
        #expect(queue.dequeue() == 5)
    }

    @Test("Priority queue from sequence")
    func testPriorityQueueFromSequence() {
        var queue = PriorityQueue([5, 3, 7, 1, 9], isMinQueue: true)

        #expect(queue.count == 5)
        #expect(queue.dequeue() == 1)
    }

    @Test("Empty queue")
    func testEmptyQueue() {
        var queue = PriorityQueue<Int>()
        #expect(queue.isEmpty)
        #expect(queue.peek == nil)
        #expect(queue.dequeue() == nil)
    }

    @Test("Sequence conformance")
    func testSequenceConformance() {
        let queue = PriorityQueue([5, 3, 7, 1, 9], isMinQueue: true)
        let sorted = Array(queue)

        #expect(sorted == [1, 3, 5, 7, 9])
    }
}

@Suite("Circular Buffer Tests")
struct CircularBufferTests {
    @Test("Buffer initialization")
    func testBufferInit() throws {
        let buffer = try CircularBuffer<Int>(capacity: 5)
        #expect(buffer.isEmpty)
        #expect(buffer.capacity == 5)
        #expect(buffer.count == 0)
        #expect(buffer.availableSpace == 5)
    }

    @Test("Invalid capacity throws")
    func testInvalidCapacity() {
        #expect(throws: StructError.self) {
            try CircularBuffer<Int>(capacity: 0)
        }
    }

    @Test("Write and read")
    func testWriteRead() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)

        let write1 = buffer.write(1)
        #expect(write1)
        let write2 = buffer.write(2)
        #expect(write2)
        #expect(buffer.count == 2)

        let read1 = buffer.read()
        #expect(read1 == 1)
        let read2 = buffer.read()
        #expect(read2 == 2)
        #expect(buffer.isEmpty)
    }

    @Test("Full buffer")
    func testFullBuffer() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)

        let write1 = buffer.write(1)
        #expect(write1)
        let write2 = buffer.write(2)
        #expect(write2)
        let write3 = buffer.write(3)
        #expect(write3)
        #expect(buffer.isFull)
        let write4 = buffer.write(4)
        #expect(!write4)
    }

    @Test("Front and back")
    func testFrontBack() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)
        buffer.write(1)
        buffer.write(2)
        buffer.write(3)

        #expect(buffer.front == 1)
        #expect(buffer.back == 3)
    }

    @Test("Overwrite")
    func testOverwrite() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)
        buffer.write(1)
        buffer.write(2)
        buffer.write(3)

        buffer.overwrite(4)
        #expect(buffer.front == 2)
        #expect(buffer.back == 4)
        #expect(buffer.count == 3)
    }

    @Test("Circular behavior")
    func testCircularBehavior() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)
        buffer.write(1)
        buffer.write(2)
        buffer.write(3)

        _ = buffer.read()
        _ = buffer.read()

        let write4 = buffer.write(4)
        #expect(write4)
        let write5 = buffer.write(5)
        #expect(write5)

        let elements = buffer.elements
        #expect(elements == [3, 4, 5])
    }

    @Test("Clear buffer")
    func testClear() throws {
        var buffer = try CircularBuffer<Int>(capacity: 3)
        buffer.write(1)
        buffer.write(2)
        buffer.write(3)

        buffer.clear()
        #expect(buffer.isEmpty)
        #expect(buffer.count == 0)
    }

    @Test("Sequence conformance")
    func testSequenceConformance() throws {
        var buffer = try CircularBuffer<Int>(capacity: 5)
        buffer.write(1)
        buffer.write(2)
        buffer.write(3)

        let elements = Array(buffer)
        #expect(elements == [1, 2, 3])
    }
}
