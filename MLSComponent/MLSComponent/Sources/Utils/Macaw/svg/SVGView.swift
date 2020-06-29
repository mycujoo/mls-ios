import Foundation

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

class SVGView: MacawView {

    @IBInspectable var fileName: String? {
        didSet {
            node = (try? SVGParser.parse(resource: fileName ?? "")) ?? Group()
        }
    }

    init(node: Node, frame: CGRect) {
        super.init(frame: frame)
        self.node = node
    }

    @objc override init?(node: Node, coder aDecoder: NSCoder) {
        super.init(node: node, coder: aDecoder)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(node: Group(), coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func initializeView() {
        super.initializeView()
        self.contentLayout = ContentLayout.of(contentMode: contentMode)
    }

}
