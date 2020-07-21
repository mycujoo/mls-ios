import Foundation

class PathSegment {

    let type: PathSegmentType
    let data: [Double]

    init(type: PathSegmentType = .M, data: [Double] = []) {
        self.type = type
        self.data = data
    }

    func isAbsolute() -> Bool {
        switch type {
        case .M, .L, .H, .V, .C, .S, .Q, .T, .A, .E:
            return true
        default:
            return false
        }
    }
}
