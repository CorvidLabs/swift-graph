import Testing
@testable import Graph

@Suite("Bloom Filter Tests")
struct BloomFilterTests {
    @Test("Initialization with size and hash count")
    func testInitialization() {
        let filter = BloomFilter<String>(size: 100, hashFunctionCount: 3)
        #expect(filter.size == 100)
    }

    @Test("Initialization with expected count")
    func testInitializationWithExpectedCount() {
        let filter = BloomFilter<String>(expectedCount: 1000, falsePositiveRate: 0.01)
        #expect(filter.size > 0)
    }

    @Test("Insert and contains")
    func testInsertContains() {
        var filter = BloomFilter<String>(size: 100, hashFunctionCount: 3)

        filter.insert("apple")
        filter.insert("banana")
        filter.insert("cherry")

        #expect(filter.contains("apple"))
        #expect(filter.contains("banana"))
        #expect(filter.contains("cherry"))
    }

    @Test("Definitely not in set")
    func testDefinitelyNotInSet() {
        var filter = BloomFilter<String>(size: 100, hashFunctionCount: 3)

        filter.insert("apple")
        filter.insert("banana")

        // These should definitely not be in the set (barring hash collision)
        // We test a few to reduce probability of false positives
        let notInserted = ["zebra", "xylophone", "quantum", "neutrino"]
        var allCorrect = true

        for item in notInserted {
            if filter.contains(item) {
                allCorrect = false
                break
            }
        }

        // In a properly functioning Bloom filter with reasonable parameters,
        // this should pass most of the time
        #expect(allCorrect)
    }

    @Test("Fill ratio")
    func testFillRatio() {
        var filter = BloomFilter<Int>(size: 100, hashFunctionCount: 3)

        let initialRatio = filter.fillRatio
        #expect(initialRatio == 0.0)

        filter.insert(1)
        filter.insert(2)
        filter.insert(3)

        let afterInsertRatio = filter.fillRatio
        #expect(afterInsertRatio > 0.0)
    }

    @Test("Union operation")
    func testUnion() {
        var filter1 = BloomFilter<String>(size: 100, hashFunctionCount: 3)
        var filter2 = BloomFilter<String>(size: 100, hashFunctionCount: 3)

        filter1.insert("apple")
        filter1.insert("banana")

        filter2.insert("cherry")
        filter2.insert("date")

        guard let union = filter1.union(filter2) else {
            #expect(Bool(false), "Union should succeed")
            return
        }

        #expect(union.contains("apple"))
        #expect(union.contains("banana"))
        #expect(union.contains("cherry"))
        #expect(union.contains("date"))
    }

    @Test("Union with incompatible filters")
    func testUnionIncompatible() {
        var filter1 = BloomFilter<String>(size: 100, hashFunctionCount: 3)
        var filter2 = BloomFilter<String>(size: 200, hashFunctionCount: 3)

        filter1.insert("apple")
        filter2.insert("banana")

        let union = filter1.union(filter2)
        #expect(union == nil)
    }

    @Test("Intersection operation")
    func testIntersection() {
        var filter1 = BloomFilter<String>(size: 100, hashFunctionCount: 3)
        var filter2 = BloomFilter<String>(size: 100, hashFunctionCount: 3)

        filter1.insert("apple")
        filter1.insert("banana")
        filter1.insert("cherry")

        filter2.insert("banana")
        filter2.insert("cherry")
        filter2.insert("date")

        guard let intersection = filter1.intersection(filter2) else {
            #expect(Bool(false), "Intersection should succeed")
            return
        }

        // Items in both filters should be in intersection
        #expect(intersection.contains("banana"))
        #expect(intersection.contains("cherry"))
    }

    @Test("Clear filter")
    func testClear() {
        var filter = BloomFilter<String>(size: 100, hashFunctionCount: 3)

        filter.insert("apple")
        filter.insert("banana")

        #expect(filter.contains("apple"))

        filter.clear()
        #expect(filter.fillRatio == 0.0)
    }

    @Test("Integer elements")
    func testIntegerElements() {
        var filter = BloomFilter<Int>(size: 100, hashFunctionCount: 3)

        for i in 1...10 {
            filter.insert(i)
        }

        for i in 1...10 {
            #expect(filter.contains(i))
        }
    }

    @Test("False positive probability increases with insertions")
    func testFalsePositiveProbability() {
        var filter = BloomFilter<Int>(size: 100, hashFunctionCount: 3)

        let initialProb = filter.approximateFalsePositiveProbability

        for i in 1...50 {
            filter.insert(i)
        }

        let afterInsertProb = filter.approximateFalsePositiveProbability
        #expect(afterInsertProb > initialProb)
    }
}
