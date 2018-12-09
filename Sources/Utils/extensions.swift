
extension Dictionary where Value: Numeric {
    /// Increment numeric value for key, non-existing keys are treated as zero.
    @discardableResult
    public mutating func increment(_ key: Key, by step: Value = 1) -> Value {
        if let current = self[key] {
            self[key] = current + step
        } else {
            self[key] = step
        }
        return self[key]!
    }
}
