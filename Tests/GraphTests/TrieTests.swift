import Testing
@testable import Graph

@Suite("Trie Tests")
struct TrieTests {
    @Test("Empty trie")
    func testEmptyTrie() {
        let trie = Trie<Character>()
        #expect(trie.isEmpty)
        #expect(trie.count == 0)
    }

    @Test("Insert and contains")
    func testInsertContains() {
        let trie = Trie<Character>()
        trie.insert("cat")
        trie.insert("dog")

        #expect(trie.contains("cat"))
        #expect(trie.contains("dog"))
        #expect(!trie.contains("car"))
        #expect(trie.count == 2)
    }

    @Test("Prefix checking")
    func testHasPrefix() {
        let trie = Trie<Character>()
        trie.insert("hello")
        trie.insert("help")

        #expect(trie.hasPrefix("hel"))
        #expect(trie.hasPrefix("hello"))
        #expect(!trie.hasPrefix("world"))
    }

    @Test("Find strings with prefix")
    func testStringsWithPrefix() {
        let trie = Trie<Character>()
        trie.insert("cat")
        trie.insert("car")
        trie.insert("card")
        trie.insert("dog")

        let withCar = trie.strings(withPrefix: "car")
        #expect(withCar.count == 2)
        #expect(withCar.contains("car"))
        #expect(withCar.contains("card"))
    }

    @Test("Remove word")
    func testRemove() {
        let trie = Trie<Character>()
        trie.insert("cat")
        trie.insert("car")

        #expect(trie.remove("cat"))
        #expect(!trie.contains("cat"))
        #expect(trie.contains("car"))
        #expect(trie.count == 1)

        #expect(!trie.remove("dog"))
    }

    @Test("All strings")
    func testAllStrings() {
        let words = ["cat", "dog", "car"]
        let trie = Trie(words)

        let allStrings = trie.allStrings
        #expect(allStrings.count == 3)
        #expect(allStrings.contains("cat"))
        #expect(allStrings.contains("dog"))
        #expect(allStrings.contains("car"))
    }

    @Test("Generic sequences")
    func testGenericSequences() {
        let trie = Trie<Int>()
        trie.insert([1, 2, 3])
        trie.insert([1, 2, 4])
        trie.insert([2, 3, 4])

        #expect(trie.contains([1, 2, 3]))
        #expect(trie.hasPrefix([1, 2]))
        #expect(trie.count == 3)

        let withPrefix = trie.sequences(withPrefix: [1, 2])
        #expect(withPrefix.count == 2)
    }

    @Test("Remove all")
    func testRemoveAll() {
        let trie = Trie(["cat", "dog", "car"])
        trie.removeAll()

        #expect(trie.isEmpty)
        #expect(trie.count == 0)
    }
}

@Suite("Trie Node Tests")
struct TrieNodeTests {
    @Test("Node initialization")
    func testNodeInit() {
        let node = TrieNode<Character>()
        #expect(node.element == nil)
        #expect(!node.isTerminating)
        #expect(node.isLeaf)
    }

    @Test("Add child")
    func testAddChild() {
        let node = TrieNode<Character>()
        let child = node.addChild(for: "a")

        #expect(child.element == "a")
        #expect(!node.isLeaf)
        #expect(node.childCount == 1)
    }

    @Test("Get child")
    func testGetChild() {
        let node = TrieNode<Character>()
        node.addChild(for: "a")

        let child = node.child(for: "a")
        #expect(child != nil)
        #expect(child?.element == "a")

        #expect(node.child(for: "b") == nil)
    }

    @Test("Remove child")
    func testRemoveChild() {
        let node = TrieNode<Character>()
        node.addChild(for: "a")
        node.addChild(for: "b")

        #expect(node.childCount == 2)

        node.removeChild(for: "a")
        #expect(node.childCount == 1)
        #expect(node.child(for: "a") == nil)
    }
}
