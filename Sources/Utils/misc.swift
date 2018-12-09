/// Read all lines from stdin until EOF.
public func readLines() -> [String] {
    var rv = Array<String>()
    while let line = readLine() {
        rv.append(line)
    }
    return rv
}
