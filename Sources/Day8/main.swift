import Utils

let input = readLine()!.split(separator: " ").map { Int($0)! }

struct Node {
    let metadata: [Int]
    let children: [Node]
}

struct LicenseReader {
    var pos: Int
    var data: [Int]
    init(_ data: [Int]) {
        self.data = data
        pos = data.startIndex
    }

    mutating func read() -> Int {
        let rv = data[pos]
        pos += 1
        return rv
    }

    mutating func read(_ n: Int) -> [Int] {
        let rv = data[pos ..< pos + n]
        pos += n
        return Array(rv)
    }
}

var reader = LicenseReader(input)

func parseNode(_ reader: inout LicenseReader) -> Node {
    let numChildren = reader.read()
    let metadataLen = reader.read()
    let children = (0 ..< numChildren).map { _ -> Node in
        return parseNode(&reader)
    }
    let metadata = reader.read(metadataLen)
    return Node(metadata: metadata, children: children)
}

let root = parseNode(&reader)

func part1(_ node: Node) -> Int {
    var rv = node.metadata.reduce(0) { $0 + $1 }
    rv += node.children.reduce(0, { $0 + part1($1) })
    return rv
}

print("License 1: \(part1(root))")

func part2(_ node: Node) -> Int {
    var rv = 0
    if node.children.count == 0 {
        rv = node.metadata.reduce(0) { $0 + $1 }
    } else {
        for idx in node.metadata {
            if idx == 0 || idx > node.children.count { continue }
            rv += part2(node.children[idx - 1])
        }
    }
    return rv
}

print("License 2: \(part2(root))")
