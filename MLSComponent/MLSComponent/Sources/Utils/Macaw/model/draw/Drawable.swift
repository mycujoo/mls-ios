import Foundation

class Drawable: NSObject {

    let visible: Bool
    let tag: [String]

    init(visible: Bool = true, tag: [String] = []) {
        self.visible = visible
        self.tag = tag
    }
}
