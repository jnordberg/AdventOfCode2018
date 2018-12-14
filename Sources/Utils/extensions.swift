import Foundation

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

extension Character {
    public var isUpperCase: Bool {
        return CharacterSet.uppercaseLetters.contains(unicodeScalars.first!)
    }

    public var isLowerCase: Bool {
        return CharacterSet.lowercaseLetters.contains(unicodeScalars.first!)
    }
}

extension Sequence {
    public func extent(by comparator: (Element, Element) -> Bool) -> (min: Element, max: Element)? {
        guard let min = self.min(by: comparator), let max = self.max(by: comparator) else {
            return nil
        }
        return (min, max)
    }
}

extension Sequence where Element: Comparable {
    public func extent() -> (min: Element, max: Element)? {
        guard let min = self.min(), let max = self.max() else {
            return nil
        }
        return (min, max)
    }
}
