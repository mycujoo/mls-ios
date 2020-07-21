class Fill: Equatable {

    init() {
    }

    func equals<T>(other: T) -> Bool where T: Fill {
        fatalError("Equals can't be realised for  Fill")
    }
}

func ==<T> (lhs: T, rhs: T) -> Bool where T: Fill {
    return lhs.equals(other: rhs)
}
