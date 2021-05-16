class Circle: Locus {

    let cx: Double
    let cy: Double
    let r: Double

    init(cx: Double = 0, cy: Double = 0, r: Double = 0) {
        self.cx = cx
        self.cy = cy
        self.r = r
    }

    override func bounds() -> Rect {
        return Rect(
            x: cx - r,
            y: cy - r,
            w: r * 2.0,
            h: r * 2.0)
    }

    func arc(shift: Double, extent: Double) -> Arc {
        return Arc(ellipse: Ellipse(cx: cx, cy: cy, rx: r, ry: r), shift: shift, extent: extent)
    }

    override func toPath() -> Path {
        return MoveTo(x: cx, y: cy).m(-r, 0).a(r, r, 0.0, true, false, r * 2.0, 0.0).a(r, r, 0.0, true, false, -(r * 2.0), 0.0).build()
    }
}
