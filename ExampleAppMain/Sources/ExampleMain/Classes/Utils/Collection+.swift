import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//extension Sequence where Element: AdditiveArithmetic {
//    /// Returns the total sum of all elements in the sequence
//    func sum() -> Element { reduce(.zero, +) }
//}
//
//extension Collection where Element: BinaryInteger {
//    /// Returns the average of all elements in the array
//    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
//    /// Returns the average of all elements in the array as Floating Point type
//    func average<T: FloatingPoint>() -> T { isEmpty ? .zero : T(sum()) / T(count) }
//}
//
//extension Collection where Element: BinaryFloatingPoint {
//    /// Returns the average of all elements in the array
//    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
//}

extension Sequence  {
    /// Returns the total sum of all  mapped elements
    func sum<T: AdditiveArithmetic>(map: (Element) -> T) -> T {
        reduce(.zero) { $0 + map($1) }
    }
}

extension Collection {
    func average<T: BinaryInteger>(map: (Element) -> T) -> T {
        sum(map: map) / T(count)
    }
    func average<T: BinaryInteger, F: BinaryFloatingPoint>(map: (Element) -> T) -> F {
        F(sum(map: map)) / F(count)
    }
    func average<T: BinaryFloatingPoint>(map: (Element) -> T) -> T {
        sum(map: map) / T(count)
    }
    func average(_ map: (Element) -> Decimal) -> Decimal {
        sum(map: map) / Decimal(count)
    }
}
