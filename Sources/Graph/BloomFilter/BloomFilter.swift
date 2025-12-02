import Foundation

/// A probabilistic data structure for testing set membership
///
/// A Bloom filter can tell you if an element is definitely not in a set,
/// or if it might be in the set (with a small probability of false positives).
public struct BloomFilter<Element: Hashable>: Sendable where Element: Sendable {
    private var bits: [Bool]
    private let hashFunctionCount: Int

    /// The size of the bit array
    public let size: Int

    /// Creates a Bloom filter with the specified size and number of hash functions
    ///
    /// - Parameters:
    ///   - size: The size of the bit array
    ///   - hashFunctionCount: The number of hash functions to use
    public init(size: Int, hashFunctionCount: Int) {
        self.size = size
        self.hashFunctionCount = hashFunctionCount
        self.bits = Array(repeating: false, count: size)
    }

    /// Creates a Bloom filter optimized for the expected number of elements and desired false positive rate
    ///
    /// - Parameters:
    ///   - expectedCount: The expected number of elements
    ///   - falsePositiveRate: The desired false positive rate (between 0 and 1)
    public init(expectedCount: Int, falsePositiveRate: Double = 0.01) {
        let size = Self.optimalSize(expectedCount: expectedCount, falsePositiveRate: falsePositiveRate)
        let hashCount = Self.optimalHashCount(size: size, expectedCount: expectedCount)
        self.init(size: size, hashFunctionCount: hashCount)
    }

    /// Calculates the optimal bit array size
    private static func optimalSize(expectedCount: Int, falsePositiveRate: Double) -> Int {
        let numerator = -Double(expectedCount) * log(falsePositiveRate)
        let denominator = pow(log(2.0), 2)
        return max(1, Int(ceil(numerator / denominator)))
    }

    /// Calculates the optimal number of hash functions
    private static func optimalHashCount(size: Int, expectedCount: Int) -> Int {
        let count = (Double(size) / Double(expectedCount)) * log(2.0)
        return max(1, Int(round(count)))
    }

    /// Inserts an element into the Bloom filter
    ///
    /// - Parameter element: The element to insert
    public mutating func insert(_ element: Element) {
        for index in hashIndices(for: element) {
            bits[index] = true
        }
    }

    /// Checks if an element might be in the set
    ///
    /// - Parameter element: The element to check
    /// - Returns: True if the element might be in the set, false if it's definitely not
    public func contains(_ element: Element) -> Bool {
        hashIndices(for: element).allSatisfy { bits[$0] }
    }

    /// Generates hash indices for an element
    private func hashIndices(for element: Element) -> [Int] {
        var indices: [Int] = []
        var hasher = element.hashValue

        for i in 0..<hashFunctionCount {
            // Generate different hash values using double hashing
            let hash1 = abs(hasher)
            let hash2 = abs(hasher &* 31 &+ i)
            let combinedHash = (hash1 &+ (i &* hash2)) % size
            indices.append(abs(combinedHash))

            // Update hasher for next iteration
            hasher = hasher &* 31 &+ i
        }

        return indices
    }

    /// Returns the approximate fill ratio of the filter
    public var fillRatio: Double {
        let setBits = bits.filter { $0 }.count
        return Double(setBits) / Double(size)
    }

    /// Returns the approximate false positive probability based on current fill ratio
    public var approximateFalsePositiveProbability: Double {
        let p = fillRatio
        return pow(p, Double(hashFunctionCount))
    }

    /// Clears all elements from the filter
    public mutating func clear() {
        bits = Array(repeating: false, count: size)
    }

    /// Creates a union of two Bloom filters
    ///
    /// - Parameter other: Another Bloom filter
    /// - Returns: A new Bloom filter containing elements from both filters
    /// - Note: Both filters must have the same size and hash function count
    public func union(_ other: BloomFilter<Element>) -> BloomFilter<Element>? {
        guard size == other.size && hashFunctionCount == other.hashFunctionCount else {
            return nil
        }

        var result = self
        for i in 0..<size {
            result.bits[i] = bits[i] || other.bits[i]
        }
        return result
    }

    /// Creates an intersection of two Bloom filters
    ///
    /// - Parameter other: Another Bloom filter
    /// - Returns: A new Bloom filter containing elements common to both filters
    /// - Note: Both filters must have the same size and hash function count
    public func intersection(_ other: BloomFilter<Element>) -> BloomFilter<Element>? {
        guard size == other.size && hashFunctionCount == other.hashFunctionCount else {
            return nil
        }

        var result = self
        for i in 0..<size {
            result.bits[i] = bits[i] && other.bits[i]
        }
        return result
    }
}

extension BloomFilter: CustomStringConvertible {
    public var description: String {
        let fpProb = String(format: "%.4f", approximateFalsePositiveProbability)
        return "BloomFilter(size: \(size), hashFunctions: \(hashFunctionCount), fillRatio: \(String(format: "%.2f%%", fillRatio * 100)), ~FP: \(fpProb))"
    }
}
