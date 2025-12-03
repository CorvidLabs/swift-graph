/// A trie (prefix tree) data structure for efficient string operations
public struct Trie<Element: Hashable>: Sendable where Element: Sendable {
    private let root: TrieNode<Element>

    /// Creates an empty trie
    public init() {
        self.root = TrieNode()
    }

    /**
     Creates a trie with the given sequences

     - Parameter sequences: Sequences to insert into the trie
     */
    public init<S: Sequence, T: Sequence>(_ sequences: S) where S.Element == T, T.Element == Element {
        self.init()
        for sequence in sequences {
            insert(sequence)
        }
    }

    /**
     Inserts a sequence into the trie

     - Parameter sequence: The sequence to insert
     */
    public func insert<S: Sequence>(_ sequence: S) where S.Element == Element {
        var currentNode = root
        for element in sequence {
            currentNode = currentNode.addChild(for: element)
        }
        currentNode.isTerminating = true
    }

    /**
     Checks if the trie contains a sequence

     - Parameter sequence: The sequence to search for
     - Returns: True if the sequence exists in the trie
     */
    public func contains<S: Sequence>(_ sequence: S) -> Bool where S.Element == Element {
        var currentNode = root
        for element in sequence {
            guard let child = currentNode.child(for: element) else {
                return false
            }
            currentNode = child
        }
        return currentNode.isTerminating
    }

    /**
     Checks if any sequence in the trie starts with the given prefix

     - Parameter prefix: The prefix to search for
     - Returns: True if any sequence starts with the prefix
     */
    public func hasPrefix<S: Sequence>(_ prefix: S) -> Bool where S.Element == Element {
        var currentNode = root
        for element in prefix {
            guard let child = currentNode.child(for: element) else {
                return false
            }
            currentNode = child
        }
        return true
    }

    /**
     Returns all sequences that start with the given prefix

     - Parameter prefix: The prefix to search for
     - Returns: Array of sequences that start with the prefix
     */
    public func sequences<S: Sequence>(withPrefix prefix: S) -> [[Element]] where S.Element == Element {
        var currentNode = root
        var prefixArray: [Element] = []

        // Navigate to the node representing the prefix
        for element in prefix {
            guard let child = currentNode.child(for: element) else {
                return []
            }
            currentNode = child
            prefixArray.append(element)
        }

        // Collect all sequences from this node
        return collectSequences(from: currentNode, prefix: prefixArray)
    }

    private func collectSequences(from node: TrieNode<Element>, prefix: [Element]) -> [[Element]] {
        var results: [[Element]] = []

        if node.isTerminating {
            results.append(prefix)
        }

        for (element, childNode) in node.children {
            let childResults = collectSequences(from: childNode, prefix: prefix + [element])
            results.append(contentsOf: childResults)
        }

        return results
    }

    /**
     Removes a sequence from the trie

     - Parameter sequence: The sequence to remove
     - Returns: True if the sequence was found and removed
     */
    @discardableResult
    public func remove<S: Sequence>(_ sequence: S) -> Bool where S.Element == Element {
        remove(sequence, from: root)
    }

    private func remove<S: Sequence>(_ sequence: S, from node: TrieNode<Element>) -> Bool where S.Element == Element {
        var elements = Array(sequence)
        guard !elements.isEmpty else {
            if node.isTerminating {
                node.isTerminating = false
                return true
            }
            return false
        }

        let element = elements.removeFirst()
        guard let child = node.child(for: element) else {
            return false
        }

        let wasRemoved = remove(elements, from: child)

        // Remove child node if it's now empty and not terminating
        if wasRemoved && child.isLeaf && !child.isTerminating {
            node.removeChild(for: element)
        }

        return wasRemoved
    }

    /// Returns all sequences in the trie
    public var allSequences: [[Element]] {
        collectSequences(from: root, prefix: [])
    }

    /// Returns the number of sequences in the trie
    public var count: Int {
        countSequences(from: root)
    }

    private func countSequences(from node: TrieNode<Element>) -> Int {
        var count = node.isTerminating ? 1 : 0
        for child in node.children.values {
            count += countSequences(from: child)
        }
        return count
    }

    /// Returns true if the trie is empty
    public var isEmpty: Bool {
        root.isLeaf
    }

    /// Removes all sequences from the trie
    public func removeAll() {
        root.children.removeAll()
        root.isTerminating = false
    }
}

// MARK: - String-specific extensions

extension Trie where Element == Character {
    /**
     Creates a trie from an array of strings

     - Parameter strings: Strings to insert into the trie
     */
    public init(_ strings: [String]) {
        self.init()
        for string in strings {
            insert(string)
        }
    }

    /**
     Inserts a string into the trie

     - Parameter string: The string to insert
     */
    public func insert(_ string: String) {
        insert(Array(string))
    }

    /**
     Checks if the trie contains a string

     - Parameter string: The string to search for
     - Returns: True if the string exists in the trie
     */
    public func contains(_ string: String) -> Bool {
        contains(Array(string))
    }

    /**
     Checks if any string in the trie starts with the given prefix

     - Parameter prefix: The prefix to search for
     - Returns: True if any string starts with the prefix
     */
    public func hasPrefix(_ prefix: String) -> Bool {
        hasPrefix(Array(prefix))
    }

    /**
     Returns all strings that start with the given prefix

     - Parameter prefix: The prefix to search for
     - Returns: Array of strings that start with the prefix
     */
    public func strings(withPrefix prefix: String) -> [String] {
        sequences(withPrefix: Array(prefix))
            .map { String($0) }
    }

    /**
     Removes a string from the trie

     - Parameter string: The string to remove
     - Returns: True if the string was found and removed
     */
    @discardableResult
    public func remove(_ string: String) -> Bool {
        remove(Array(string))
    }

    /// Returns all strings in the trie
    public var allStrings: [String] {
        allSequences.map { String($0) }
    }
}

extension Trie: CustomStringConvertible {
    public var description: String {
        "Trie(count: \(count))"
    }
}
