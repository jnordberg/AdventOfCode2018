
/// Type describing a directed acyclic graph.
/// - note: Behaviour is undefined for cyclic graphs.
public struct DirectedGraph<Node: Hashable> {
    public struct Edge {
        let from: Node
        let to: Node
    }

    public var graph: [Node: [Edge]] = [:]

    public var nodes: [Node] {
        return Array(graph.keys)
    }

    public init() {}

    public mutating func addEdge(_ edge: Edge) {
        graph[edge.from, default: []].append(edge)
        if graph[edge.to] == nil {
            graph[edge.to] = []
        }
    }

    public mutating func addEdge(from: Node, to: Node) {
        addEdge(Edge(from: from, to: to))
    }

    public func neighbors(for node: Node) -> [Node] {
        return graph[node, default: []].map { $0.to }
    }

    public func inDegree(for node: Node) -> Int {
        var rv = 0
        for edges in graph.values {
            if edges.contains(where: { $0.to == node }) {
                rv += 1
            }
        }
        return rv
    }

    public func topologicallySorted() -> [Node] {
        var rv = Array<Node>()
        func visit(_ node: Node) {
            if rv.contains(node) { return }
            for n in nodes where neighbors(for: node).contains(n) {
                visit(n)
            }
            rv.insert(node, at: 0)
        }
        for node in nodes {
            visit(node)
        }
        return rv
    }

    /// Traverse the graph, visitor is given a set of nodes and should return one of them as the next step.
    public func topologicalWalk(visitor: (Set<Node>) -> Node) {
        var degrees = Dictionary<Node, Int>(
            uniqueKeysWithValues: nodes.map { ($0, inDegree(for: $0)) }
        )
        var available = Set(degrees
            .filter { $0.value == 0 }
            .map { $0.key })
        while !available.isEmpty {
            let next = visitor(available)
            available.remove(next)
            for node in neighbors(for: next) {
                degrees[node, default: 0] -= 1
                if degrees[node] == 0 {
                    available.insert(node)
                }
            }
        }
    }

    public func topologicallySorted(using comparator: (Node, Node) -> Bool) -> [Node] {
        var rv = Array<Node>()
        topologicalWalk { (available) -> Node in
            let next = available.min(by: comparator)!
            rv.append(next)
            return next
        }
        return rv
    }
}
