---
module: graph
version: 1
status: active
files:
  - Package.swift

db_tables: []
depends_on: []
---

# Swift Graph and Data Structures

## Purpose

Provide the existing pure-Swift graph algorithms, trees, heaps, tries, queues, circular buffers, and Bloom filters with value semantics and concurrency-safe public types.

## Public API

### Package Interface

The `Graph` library product exposes directed and undirected weighted graphs and algorithms, binary trees and search trees, heaps, tries, deques, priority queues, circular buffers, Bloom filters, edges, and typed structural errors.

## Invariants

1. Graph traversal, path, cycle, and topological algorithms preserve the existing directedness, weight, and missing-vertex behavior.
2. Tree, heap, queue, deque, and circular-buffer mutations preserve ordering, capacity, and empty-state invariants.
3. Trie prefix operations preserve inserted membership and deterministic matching behavior.
4. Bloom filters never return false negatives for inserted elements while retaining probabilistic false positives.
5. Public generic and concurrent-use behavior remains type-safe and `Sendable` as currently implemented.

## Behavioral Examples

```
Given a directed weighted graph with a reachable destination
When the shortest-path algorithm executes
Then it returns the existing minimum-cost route while rejecting missing vertices consistently
```

## Error Cases

| Error | When | Behavior |
|-------|------|----------|
| Missing vertex | A graph operation references an absent vertex | Return the existing graph error |
| Cycle | A topological operation encounters a directed cycle | Return the cycle failure |
| Empty structure | Removal or access requires an unavailable element | Return the documented optional or typed error |
| Invalid capacity | A fixed-capacity structure is created with an invalid size | Reject initialization |

## Dependencies

- Swift 6.0 or newer
- Swift-DocC plugin for independent documentation publication

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1 | 2026-07-12 | Initial spec |
