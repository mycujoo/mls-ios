class Color: Fill {

    let val: Int

    static let white = Color(0xFFFFFF)
    static let silver = Color(0xC0C0C0)
    static let gray = Color(0x808080)
    static let black = Color(0)
    static let red = Color(0xFF0000)
    static let maroon = Color(0x800000)
    static let yellow = Color(0xFFFF00)
    static let olive = Color(0x808000)
    static let lime = Color(0x00FF00)
    static let green = Color(0x008000)
    static let aqua = Color(0x00FFFF)
    static let teal = Color(0x008080)
    static let blue = Color(0x0000FF)
    static let navy = Color(0x000080)
    static let fuchsia = Color(0xFF00FF)
    static let purple = Color(0x800080)

    static let clear = Color.rgba(r: 0, g: 0, b: 0, a: 0)

    static let aliceBlue = Color(0xf0f8ff)
    static let antiqueWhite = Color(0xfaebd7)
    static let aquamarine = Color(0x7fffd4)
    static let azure = Color(0xf0ffff)
    static let beige = Color(0xf5f5dc)
    static let bisque = Color(0xffe4c4)
    static let blanchedAlmond = Color(0xffebcd)
    static let blueViolet = Color(0x8a2be2)
    static let brown = Color(0xa52a2a)
    static let burlywood = Color(0xdeb887)
    static let cadetBlue = Color(0x5f9ea0)
    static let chartreuse = Color(0x7fff00)
    static let chocolate = Color(0xd2691e)
    static let coral = Color(0xff7f50)
    static let cornflowerBlue = Color(0x6495ed)
    static let cornsilk = Color(0xfff8dc)
    static let crimson = Color(0xdc143c)
    static let cyan = Color(0x00ffff)
    static let darkBlue = Color(0x00008b)
    static let darkCyan = Color(0x008b8b)
    static let darkGoldenrod = Color(0xb8860b)
    static let darkGray = Color(0xa9a9a9)
    static let darkGreen = Color(0x006400)
    static let darkKhaki = Color(0xbdb76b)
    static let darkMagenta = Color(0x8b008b)
    static let darkOliveGreen = Color(0x556b2f)
    static let darkOrange = Color(0xff8c00)
    static let darkOrchid = Color(0x9932cc)
    static let darkRed = Color(0x8b0000)
    static let darkSalmon = Color(0xe9967a)
    static let darkSeaGreen = Color(0x8fbc8f)
    static let darkSlateBlue = Color(0x483d8b)
    static let darkSlateGray = Color(0x2f4f4f)
    static let darkTurquoise = Color(0x00ced1)
    static let darkViolet = Color(0x9400d3)
    static let deepPink = Color(0xff1493)
    static let deepSkyBlue = Color(0x00bfff)
    static let dimGray = Color(0x696969)
    static let dodgerBlue = Color(0x1e90ff)
    static let firebrick = Color(0xb22222)
    static let floralWhite = Color(0xfffaf0)
    static let forestGreen = Color(0x228b22)
    static let gainsboro = Color(0xdcdcdc)
    static let ghostWhite = Color(0xf8f8ff)
    static let gold = Color(0xffd700)
    static let goldenrod = Color(0xdaa520)
    static let greenYellow = Color(0xadff2f)
    static let honeydew = Color(0xf0fff0)
    static let hotPink = Color(0xff69b4)
    static let indianRed = Color(0xcd5c5c)
    static let indigo = Color(0x4b0082)
    static let ivory = Color(0xfffff0)
    static let khaki = Color(0xf0e68c)
    static let lavender = Color(0xe6e6fa)
    static let lavenderBlush = Color(0xfff0f5)
    static let lawnGreen = Color(0x7cfc00)
    static let lemonChiffon = Color(0xfffacd)
    static let lightBlue = Color(0xadd8e6)
    static let lightCoral = Color(0xf08080)
    static let lightCyan = Color(0xe0ffff)
    static let lightGoldenrodYellow = Color(0xfafad2)
    static let lightGray = Color(0xd3d3d3)
    static let lightGreen = Color(0x90ee90)
    static let lightPink = Color(0xffb6c1)
    static let lightSalmon = Color(0xffa07a)
    static let lightSeaGreen = Color(0x20b2aa)
    static let lightSkyBlue = Color(0x87cefa)
    static let lightSlateGray = Color(0x778899)
    static let lightSteelBlue = Color(0xb0c4de)
    static let lightYellow = Color(0xffffe0)
    static let limeGreen = Color(0x32cd32)
    static let linen = Color(0xfaf0e6)
    static let mediumAquamarine = Color(0x66cdaa)
    static let mediumBlue = Color(0x0000cd)
    static let mediumOrchid = Color(0xba55d3)
    static let mediumPurple = Color(0x9370db)
    static let mediumSeaGreen = Color(0x3cb371)
    static let mediumSlateBlue = Color(0x7b68ee)
    static let mediumSpringGreen = Color(0x00fa9a)
    static let mediumTurquoise = Color(0x48d1cc)
    static let mediumVioletRed = Color(0xc71585)
    static let midnightBlue = Color(0x191970)
    static let mintCream = Color(0xf5fffa)
    static let mistyRose = Color(0xffe4e1)
    static let moccasin = Color(0xffe4b5)
    static let navajoWhite = Color(0xffdead)
    static let oldLace = Color(0xfdf5e6)
    static let oliveDrab = Color(0x6b8e23)
    static let orange = Color(0xffa500)
    static let orangeRed = Color(0xff4500)
    static let orchid = Color(0xda70d6)
    static let paleGoldenrod = Color(0xeee8aa)
    static let paleGreen = Color(0x98fb98)
    static let paleTurquoise = Color(0xafeeee)
    static let paleVioletRed = Color(0xdb7093)
    static let papayaWhip = Color(0xffefd5)
    static let peachPuff = Color(0xffdab9)
    static let peru = Color(0xcd853f)
    static let pink = Color(0xffc0cb)
    static let plum = Color(0xdda0dd)
    static let powderBlue = Color(0xb0e0e6)
    static let rebeccaPurple = Color(0x663399)
    static let rosyBrown = Color(0xbc8f8f)
    static let royalBlue = Color(0x4169e1)
    static let saddleBrown = Color(0x8b4513)
    static let salmon = Color(0xfa8072)
    static let sandyBrown = Color(0xf4a460)
    static let seaGreen = Color(0x2e8b57)
    static let seashell = Color(0xfff5ee)
    static let sienna = Color(0xa0522d)
    static let skyBlue = Color(0x87ceeb)
    static let slateBlue = Color(0x6a5acd)
    static let slateGray = Color(0x708090)
    static let snow = Color(0xfffafa)
    static let springGreen = Color(0x00ff7f)
    static let steelBlue = Color(0x4682b4)
    static let tan = Color(0xd2b48c)
    static let thistle = Color(0xd8bfd8)
    static let tomato = Color(0xff6347)
    static let turquoise = Color(0x40e0d0)
    static let violet = Color(0xee82ee)
    static let wheat = Color(0xf5deb3)
    static let whiteSmoke = Color(0xf5f5f5)
    static let yellowGreen = Color(0x9acd32)

    init(_ val: Int = 0) {
        self.val = val
    }

    init(val: Int = 0) {
        self.val = val
    }

    func r() -> Int {
        return ( ( val >> 16 ) & 0xff )
    }

    func g() -> Int {
        return ( ( val >> 8 ) & 0xff )
    }

    func b() -> Int {
        return ( val & 0xff )
    }

    func a() -> Int {
        return ( 255 - ( ( val >> 24 ) & 0xff ) )
    }

    func with(a: Double) -> Color {
        return Color.rgba(r: r(), g: g(), b: b(), a: a)
    }

    class func rgbt(r: Int, g: Int, b: Int, t: Int) -> Color {
        let x = ( ( t & 0xff ) << 24 )
        let y = ( ( r & 0xff ) << 16 )
        let z = ( ( g & 0xff ) << 8 )
        let q = b & 0xff
        return Color( val: ( ( ( x | y ) | z ) | q ) )
    }

    class func rgba(r: Int, g: Int, b: Int, a: Double) -> Color {
        return rgbt( r: r, g: g, b: b, t: Int( ( ( 1 - a ) * 255 ) ) )
    }

    class func rgb(r: Int, g: Int, b: Int) -> Color {
        return rgbt( r: r, g: g, b: b, t: 0 )
    }

    override func equals<T>(other: T) -> Bool where T: Fill {
        guard let other = other as? Color else {
            return false
        }
        return val == other.val
    }
}
