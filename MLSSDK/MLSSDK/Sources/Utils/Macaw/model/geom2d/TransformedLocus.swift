//
//  TransformedLocus.swift
//  Macaw
//
//  Created by Yuri Strot on 5/21/18.
//

class TransformedLocus: Locus {

    let locus: Locus
    let transform: Transform

    init(locus: Locus, transform: Transform) {
        self.locus = locus
        self.transform = transform
    }

    override func bounds() -> Rect {
        return locus.bounds().applying(transform)
    }
}
