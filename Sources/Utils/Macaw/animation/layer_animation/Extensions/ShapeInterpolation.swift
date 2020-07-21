//
//  ShapeInterpolation.swift
//  Pods
//
//  Created by Victor Sukochev on 03/02/2017.
//
//

protocol ShapeInterpolation: Interpolable {

}

extension Shape: ShapeInterpolation {
    func interpolate(_ endValue: Shape, progress: Double) -> Self {
        return self
    }
}
