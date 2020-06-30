import Foundation

class ColorMatrixEffect: Effect {

    let matrix: ColorMatrix

    init(matrix: ColorMatrix, input: Effect? = nil) {
        self.matrix = matrix
        super.init(input: input)
    }

}
