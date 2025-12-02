import Testing
@testable import Graph

@Suite("Binary Tree Tests")
struct BinaryTreeTests {
    @Test("Empty tree")
    func testEmptyTree() {
        let tree = BinaryTree<Int>()
        #expect(tree.isEmpty)
        #expect(tree.count == 0)
        #expect(tree.height == 0)
    }

    @Test("Single node tree")
    func testSingleNodeTree() {
        let tree = BinaryTree(value: 42)
        #expect(!tree.isEmpty)
        #expect(tree.count == 1)
        #expect(tree.height == 1)
        #expect(tree.value == 42)
    }

    @Test("Tree with children")
    func testTreeWithChildren() {
        let left = BinaryTree(value: 2)
        let right = BinaryTree(value: 3)
        let tree = BinaryTree(value: 1, left: left, right: right)

        #expect(tree.count == 3)
        #expect(tree.height == 2)
        #expect(tree.value == 1)
    }

    @Test("In-order traversal")
    func testInOrderTraversal() {
        let tree = BinaryTree(
            value: 2,
            left: BinaryTree(value: 1),
            right: BinaryTree(value: 3)
        )

        let inOrder = tree.inOrder()
        #expect(inOrder == [1, 2, 3])
    }

    @Test("Pre-order traversal")
    func testPreOrderTraversal() {
        let tree = BinaryTree(
            value: 2,
            left: BinaryTree(value: 1),
            right: BinaryTree(value: 3)
        )

        let preOrder = tree.preOrder()
        #expect(preOrder == [2, 1, 3])
    }

    @Test("Post-order traversal")
    func testPostOrderTraversal() {
        let tree = BinaryTree(
            value: 2,
            left: BinaryTree(value: 1),
            right: BinaryTree(value: 3)
        )

        let postOrder = tree.postOrder()
        #expect(postOrder == [1, 3, 2])
    }

    @Test("Level-order traversal")
    func testLevelOrderTraversal() {
        let tree = BinaryTree(
            value: 1,
            left: BinaryTree(value: 2, left: BinaryTree(value: 4), right: BinaryTree(value: 5)),
            right: BinaryTree(value: 3)
        )

        let levelOrder = tree.levelOrder()
        #expect(levelOrder == [1, 2, 3, 4, 5])
    }

    @Test("Map transformation")
    func testMapTransformation() {
        let tree = BinaryTree(value: 1, left: BinaryTree(value: 2), right: BinaryTree(value: 3))
        let doubled = tree.map { $0 * 2 }

        #expect(doubled.value == 2)
        #expect(doubled.inOrder() == [4, 2, 6])
    }
}

@Suite("Binary Search Tree Tests")
struct BinarySearchTreeTests {
    @Test("Empty BST")
    func testEmptyBST() {
        let bst = BinarySearchTree<Int>()
        #expect(bst.isEmpty)
        #expect(bst.count == 0)
    }

    @Test("Insert elements")
    func testInsert() {
        var bst = BinarySearchTree<Int>()
        bst.insert(5)
        bst.insert(3)
        bst.insert(7)

        #expect(bst.count == 3)
        #expect(bst.contains(5))
        #expect(bst.contains(3))
        #expect(bst.contains(7))
        #expect(!bst.contains(10))
    }

    @Test("In-order gives sorted sequence")
    func testInOrderSorted() {
        let bst = BinarySearchTree([5, 3, 7, 1, 9, 4, 6])
        let sorted = bst.inOrder()
        #expect(sorted == [1, 3, 4, 5, 6, 7, 9])
    }

    @Test("Min and max")
    func testMinMax() {
        let bst = BinarySearchTree([5, 3, 7, 1, 9])
        #expect(bst.min() == 1)
        #expect(bst.max() == 9)
    }

    @Test("Remove element")
    func testRemove() {
        var bst = BinarySearchTree([5, 3, 7, 1, 9])

        let removed = bst.remove(3)
        #expect(removed)
        #expect(!bst.contains(3))
        #expect(bst.count == 4)

        let notRemoved = bst.remove(100)
        #expect(!notRemoved)
        #expect(bst.count == 4)
    }

    @Test("Remove all")
    func testRemoveAll() {
        var bst = BinarySearchTree([5, 3, 7, 1, 9])
        bst.removeAll()
        #expect(bst.isEmpty)
        #expect(bst.count == 0)
    }
}

@Suite("Heap Tests")
struct HeapTests {
    @Test("Min heap initialization")
    func testMinHeapInit() {
        let heap = Heap<Int>(type: .minHeap)
        #expect(heap.isEmpty)
        #expect(heap.count == 0)
        #expect(heap.peek == nil)
    }

    @Test("Min heap insert and peek")
    func testMinHeapInsertPeek() {
        var heap = Heap<Int>(type: .minHeap)
        heap.insert(5)
        heap.insert(3)
        heap.insert(7)
        heap.insert(1)

        #expect(heap.count == 4)
        #expect(heap.peek == 1)
    }

    @Test("Min heap remove")
    func testMinHeapRemove() {
        var heap = Heap([5, 3, 7, 1, 9], type: .minHeap)

        #expect(heap.remove() == 1)
        #expect(heap.remove() == 3)
        #expect(heap.remove() == 5)
        #expect(heap.count == 2)
    }

    @Test("Max heap")
    func testMaxHeap() {
        var heap = Heap([5, 3, 7, 1, 9], type: .maxHeap)

        #expect(heap.peek == 9)
        #expect(heap.remove() == 9)
        #expect(heap.remove() == 7)
        #expect(heap.remove() == 5)
    }

    @Test("Heap replace")
    func testHeapReplace() {
        var heap = Heap([5, 3, 7], type: .minHeap)
        let replaced = heap.replace(with: 1)

        #expect(replaced == 3)
        #expect(heap.peek == 1)
    }

    @Test("Heap sequence")
    func testHeapSequence() {
        let heap = Heap([5, 3, 7, 1, 9], type: .minHeap)
        let sorted = Array(heap)

        #expect(sorted == [1, 3, 5, 7, 9])
    }
}
