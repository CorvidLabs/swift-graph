/// A node in a trie data structure
public final class TrieNode<Element: Hashable>: @unchecked Sendable where Element: Sendable {
    /// The element stored in this node
    public var element: Element?

    /// Child nodes mapped by their elements
    public var children: [Element: TrieNode<Element>]

    /// Indicates whether this node marks the end of a valid sequence
    public var isTerminating: Bool

    /**
     Creates a new trie node

     - Parameters:
       - element: Optional element for this node
       - isTerminating: Whether this node marks the end of a sequence
     */
    public init(element: Element? = nil, isTerminating: Bool = false) {
        self.element = element
        self.children = [:]
        self.isTerminating = isTerminating
    }

    /**
     Adds a child node for the given element

     - Parameter element: The element for the child node
     - Returns: The child node (existing or newly created)
     */
    @discardableResult
    public func addChild(for element: Element) -> TrieNode<Element> {
        if let existing = children[element] {
            return existing
        }

        let child = TrieNode(element: element)
        children[element] = child
        return child
    }

    /**
     Returns the child node for the given element

     - Parameter element: The element to look up
     - Returns: The child node, or nil if it doesn't exist
     */
    public func child(for element: Element) -> TrieNode<Element>? {
        children[element]
    }

    /**
     Removes the child node for the given element

     - Parameter element: The element whose child to remove
     */
    public func removeChild(for element: Element) {
        children.removeValue(forKey: element)
    }

    /// Returns true if this node has no children
    public var isLeaf: Bool {
        children.isEmpty
    }

    /// The number of children
    public var childCount: Int {
        children.count
    }
}

extension TrieNode: CustomStringConvertible {
    public var description: String {
        if let element = element {
            return "TrieNode(\(element), children: \(childCount), terminating: \(isTerminating))"
        } else {
            return "TrieNode(root, children: \(childCount))"
        }
    }
}
