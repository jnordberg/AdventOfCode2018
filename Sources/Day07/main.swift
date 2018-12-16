import Utils

typealias Node = Character

var graph = DirectedGraph<Node>()

for line in readLines() {
    let parts = line.split(separator: " ")
    let a = parts[1].first!
    let b = parts[7].first!
    graph.addEdge(from: a, to: b)
}

let sorted = graph.topologicallySorted { $0 < $1 }
print("Assembly order: \(String(sorted))")

let stepTimes = Dictionary<Node, Int>(uniqueKeysWithValues:
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated().map { ($0.element, 60 + $0.offset + 1) })

class Worker {
    var lastJob: Node!
    var now = 0

    var hasWork: Bool {
        return now > 0
    }

    func addJob(_ job: Node) {
        now = stepTimes[job]!
        lastJob = job
    }

    func step() {
        now -= 1
    }
}

extension Array where Element == Worker {
    func step() {
        for worker in self {
            worker.step()
        }
    }

    var active: [Worker] {
        return filter { $0.hasWork }
    }

    func getFree() -> Worker? {
        return first(where: { !$0.hasWork })
    }

    func waitFor(worker: Worker) -> Int {
        var steps = 0
        while worker.hasWork {
            steps += 1
            step()
        }
        return steps
    }
}

let numWorkers = 5
var workers: [Worker] = []

for _ in 1 ... numWorkers {
    workers.append(Worker())
}

var total = 0
var seen = Set<Node>()
graph.topologicalWalk { (nodes) -> Node in
    for node in nodes where !seen.contains(node) {
        if let worker = workers.getFree() {
            worker.addJob(node)
            seen.insert(node)
        }
    }
    let worker: Worker! = workers.active.min { $0.now < $1.now }
    total += workers.waitFor(worker: worker)
    return worker.lastJob
}

print("Time to complete: \(total)")
