/// A binary search tree that maintains elements in sorted order
public struct BinarySearchTree<Element: Comparable>: Sendable where Element: Sendable {
    private var root: Node?

    /// A node in the binary search tree
    private final class Node: @unchecked Sendable {
        var value: Element
        var left: Node?
        var right: Node?

        init(value: Element) {
            self.value = value
        }
    }

    /// Creates an empty binary search tree
    public init() {
        self.root = nil
    }

    /**
     Creates a binary search tree with the given elements

     - Parameter elements: Elements to insert into the tree
     */
    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        self.init()
        for element in elements {
            insert(element)
        }
    }

    /// Returns true if the tree is empty
    public var isEmpty: Bool {
        root == nil
    }

    /// The number of elements in the tree
    public var count: Int {
        count(from: root)
    }

    private func count(from node: Node?) -> Int {
        guard let node = node else {
            return 0
        }
        return 1 + count(from: node.left) + count(from: node.right)
    }

    /// The height of the tree
    public var height: Int {
        height(of: root)
    }

    private func height(of node: Node?) -> Int {
        guard let node = node else {
            return 0
        }
        return 1 + Swift.max(height(of: node.left), height(of: node.right))
    }

    /**
     Inserts an element into the tree

     - Parameter element: The element to insert
     */
    public mutating func insert(_ element: Element) {
        root = insert(element, into: root)
    }

    private func insert(_ element: Element, into node: Node?) -> Node {
        guard let node = node else {
            return Node(value: element)
        }

        if element < node.value {
            node.left = insert(element, into: node.left)
        } else if element > node.value {
            node.right = insert(element, into: node.right)
        }
        // If equal, don't insert duplicate

        return node
    }

    /**
     Searches for an element in the tree

     - Parameter element: The element to search for
     - Returns: True if the element exists in the tree
     */
    public func contains(_ element: Element) -> Bool {
        search(element, in: root) != nil
    }

    private func search(_ element: Element, in node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }

        if element == node.value {
            return node
        } else if element < node.value {
            return search(element, in: node.left)
        } else {
            return search(element, in: node.right)
        }
    }

    /**
     Removes an element from the tree

     - Parameter element: The element to remove
     - Returns: True if the element was found and removed
     */
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        let initialCount = count
        root = remove(element, from: root)
        return count < initialCount
    }

    private func remove(_ element: Element, from node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }

        if element < node.value {
            node.left = remove(element, from: node.left)
            return node
        } else if element > node.value {
            node.right = remove(element, from: node.right)
            return node
        } else {
            // Found the node to remove

            // Case 1: Node has no children
            if node.left == nil && node.right == nil {
                return nil
            }

            // Case 2: Node has one child
            if node.left == nil {
                return node.right
            }
            if node.right == nil {
                return node.left
            }

            // Case 3: Node has two children
            // Find the minimum value in the right subtree
            let minRight = findMin(in: node.right!)
            node.value = minRight.value
            node.right = remove(minRight.value, from: node.right)
            return node
        }
    }

    private func findMin(in node: Node) -> Node {
        var current = node
        while let left = current.left {
            current = left
        }
        return current
    }

    /**
     Returns the minimum element in the tree

     - Returns: The minimum element, or nil if the tree is empty
     */
    public func min() -> Element? {
        guard let root = root else {
            return nil
        }
        return findMin(in: root).value
    }

    /**
     Returns the maximum element in the tree

     - Returns: The maximum element, or nil if the tree is empty
     */
    public func max() -> Element? {
        guard let root = root else {
            return nil
        }
        var current = root
        while let right = current.right {
            current = right
        }
        return current.value
    }

    /**
     Performs in-order traversal

     - Returns: Array of elements in sorted order
     */
    public func inOrder() -> [Element] {
        inOrder(from: root)
    }

    private func inOrder(from node: Node?) -> [Element] {
        guard let node = node else {
            return []
        }
        return inOrder(from: node.left) + [node.value] + inOrder(from: node.right)
    }

    /**
     Performs pre-order traversal

     - Returns: Array of elements in pre-order
     */
    public func preOrder() -> [Element] {
        preOrder(from: root)
    }

    private func preOrder(from node: Node?) -> [Element] {
        guard let node = node else {
            return []
        }
        return [node.value] + preOrder(from: node.left) + preOrder(from: node.right)
    }

    /**
     Performs post-order traversal

     - Returns: Array of elements in post-order
     */
    public func postOrder() -> [Element] {
        postOrder(from: root)
    }

    private func postOrder(from node: Node?) -> [Element] {
        guard let node = node else {
            return []
        }
        return postOrder(from: node.left) + postOrder(from: node.right) + [node.value]
    }

    /// Removes all elements from the tree
    public mutating func removeAll() {
        root = nil
    }
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        guard !isEmpty else {
            return "BinarySearchTree(empty)"
        }
        return "BinarySearchTree(count: \(count), height: \(height))"
    }
}
