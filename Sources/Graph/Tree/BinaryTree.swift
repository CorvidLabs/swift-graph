/// A generic binary tree data structure
public enum BinaryTree<Element>: Sendable where Element: Sendable {
    /// An empty tree
    case empty

    /// A node with a value and left and right subtrees
    indirect case node(Element, left: BinaryTree<Element>, right: BinaryTree<Element>)

    /// Creates an empty binary tree
    public init() {
        self = .empty
    }

    /// Creates a binary tree with a single value
    ///
    /// - Parameter value: The value for the root node
    public init(value: Element) {
        self = .node(value, left: .empty, right: .empty)
    }

    /// Creates a binary tree with a value and left and right subtrees
    ///
    /// - Parameters:
    ///   - value: The value for the root node
    ///   - left: The left subtree
    ///   - right: The right subtree
    public init(value: Element, left: BinaryTree<Element>, right: BinaryTree<Element>) {
        self = .node(value, left: left, right: right)
    }

    /// The value at the root of the tree
    public var value: Element? {
        switch self {
        case .empty:
            return nil
        case .node(let value, _, _):
            return value
        }
    }

    /// The left subtree
    public var left: BinaryTree<Element>? {
        switch self {
        case .empty:
            return nil
        case .node(_, let left, _):
            return left
        }
    }

    /// The right subtree
    public var right: BinaryTree<Element>? {
        switch self {
        case .empty:
            return nil
        case .node(_, _, let right):
            return right
        }
    }

    /// Returns true if the tree is empty
    public var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        case .node:
            return false
        }
    }

    /// The number of nodes in the tree
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case .node(_, let left, let right):
            return 1 + left.count + right.count
        }
    }

    /// The height of the tree
    public var height: Int {
        switch self {
        case .empty:
            return 0
        case .node(_, let left, let right):
            return 1 + max(left.height, right.height)
        }
    }

    /// Performs in-order traversal
    ///
    /// - Returns: Array of elements in in-order
    public func inOrder() -> [Element] {
        switch self {
        case .empty:
            return []
        case .node(let value, let left, let right):
            return left.inOrder() + [value] + right.inOrder()
        }
    }

    /// Performs pre-order traversal
    ///
    /// - Returns: Array of elements in pre-order
    public func preOrder() -> [Element] {
        switch self {
        case .empty:
            return []
        case .node(let value, let left, let right):
            return [value] + left.preOrder() + right.preOrder()
        }
    }

    /// Performs post-order traversal
    ///
    /// - Returns: Array of elements in post-order
    public func postOrder() -> [Element] {
        switch self {
        case .empty:
            return []
        case .node(let value, let left, let right):
            return left.postOrder() + right.postOrder() + [value]
        }
    }

    /// Performs level-order (breadth-first) traversal
    ///
    /// - Returns: Array of elements in level-order
    public func levelOrder() -> [Element] {
        var result: [Element] = []
        var queue: [BinaryTree<Element>] = [self]

        while !queue.isEmpty {
            let current = queue.removeFirst()

            switch current {
            case .empty:
                continue
            case .node(let value, let left, let right):
                result.append(value)
                queue.append(left)
                queue.append(right)
            }
        }

        return result
    }

    /// Maps the tree's elements to a new type
    ///
    /// - Parameter transform: The transformation function
    /// - Returns: A new tree with transformed elements
    public func map<T>(_ transform: (Element) -> T) -> BinaryTree<T> where T: Sendable {
        switch self {
        case .empty:
            return .empty
        case .node(let value, let left, let right):
            return .node(
                transform(value),
                left: left.map(transform),
                right: right.map(transform)
            )
        }
    }
}

extension BinaryTree: Equatable where Element: Equatable {
    public static func == (lhs: BinaryTree<Element>, rhs: BinaryTree<Element>) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.node(let lValue, let lLeft, let lRight), .node(let rValue, let rLeft, let rRight)):
            return lValue == rValue && lLeft == rLeft && lRight == rRight
        default:
            return false
        }
    }
}

extension BinaryTree: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Empty"
        case .node(let value, _, _):
            return "BinaryTree(root: \(value), count: \(count), height: \(height))"
        }
    }
}
