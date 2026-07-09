// Affine.Continuous.Transform Tests.swift
// Tests for Affine.Continuous.Transform
//
import Dimension_Primitives
import Tagged_Primitives_Standard_Library_Integration
import Testing

//
@testable import Affine_Geometry_Primitives
@testable import Affine_Primitives
@testable import Linear_Primitives

//
@Suite
struct `Affine_Continuous_Transform Tests` {
    typealias A = Affine.Continuous<Double, Void>
    typealias L = Linear<Double, Void>
    typealias Transform = A.Transform
    typealias Point2 = A.Point<2>
    typealias Vec2 = L.Vector<2>
    typealias Matrix2x2 = L.Matrix<2, 2>
    typealias Translation = A.Translation
    typealias Dx = L.Dx
    typealias Dy = L.Dy
    //
    static func isApprox(_ a: A.X, _ b: A.X, tol: Double = 1e-10) -> Bool {
        let diff = a - b
        let tolerance = A.Dx(tol)
        return diff > -tolerance && diff < tolerance
    }
    //
    static func isApprox(_ a: A.Y, _ b: A.Y, tol: Double = 1e-10) -> Bool {
        let diff = a - b
        let tolerance = A.Dy(tol)
        return diff > -tolerance && diff < tolerance
    }
    //
    static func isApprox(_ a: L.Dx, _ b: L.Dx, tol: Double = 1e-10) -> Bool {
        let diff = a - b
        let tolerance = L.Dx(tol)
        return diff > -tolerance && diff < tolerance
    }
    //
    static func isApprox(_ a: L.Dy, _ b: L.Dy, tol: Double = 1e-10) -> Bool {
        let diff = a - b
        let tolerance = L.Dy(tol)
        return diff > -tolerance && diff < tolerance
    }
    //
    // MARK: - Identity Tests
    //
    @Suite
    struct `Identity` {
        @Test
        func `Identity transform has correct values`() {
            let id = Transform.identity
            #expect(id.a == 1)
            #expect(id.b == 0)
            #expect(id.c == 0)
            #expect(id.d == 1)
            #expect(id.tx == 0)
            #expect(id.ty == 0)
        }
        //
        @Test(arguments: [
            Point2(x: 0, y: 0),
            Point2(x: 3, y: 4),
            Point2(x: -5, y: 7),
            Point2(x: 1.5, y: -2.5),
        ])
        func `Identity preserves points`(p: Point2) {
            let id = Transform.identity
            let transformed = Transform.apply(id, to: p)
            #expect(transformed.x == p.x)
            #expect(transformed.y == p.y)
        }
        //
        @Test
        func `Identity preserves points instance method`() {
            let id = Transform.identity
            let p = Point2(x: 3, y: 4)
            let transformed = id.apply(to: p)
            #expect(transformed.x == 3)
            #expect(transformed.y == 4)
        }
    }
    //
    // MARK: - Translation Tests
    //
    @Suite
    struct `Translations` {
        @Test
        func `Translation from dx/dy`() {
            let t = Transform.translation(dx: 10, dy: 20)
            let p = Point2(x: 1, y: 2)
            let result = Transform.apply(t, to: p)
            #expect(result.x == 11)
            #expect(result.y == 22)
        }
        //
        @Test
        func `Translation from vector`() {
            let v = Vec2(dx: 10, dy: 20)
            let t = Transform.translation(v)
            let p = Point2(x: 1, y: 2)
            let result = Transform.apply(t, to: p)
            #expect(result.x == 11)
            #expect(result.y == 22)
        }
        //
        @Test
        func `Translation from Translation value`() {
            let translation = Translation(dx: 10, dy: 20)
            let t = Transform.translation(translation)
            let p = Point2(x: 1, y: 2)
            let result = Transform.apply(t, to: p)
            #expect(result.x == 11)
            #expect(result.y == 22)
        }
        //
        @Test
        func `Translation has identity linear part`() {
            let t = Transform.translation(dx: 10, dy: 20)
            #expect(t.linear == Matrix2x2.identity)
        }
    }
    //
    // MARK: - Scaling Tests
    //
    @Suite
    struct `Scaling` {
        @Test
        func `Uniform scaling`() {
            let t = Transform.scale(2)
            let p = Point2(x: 3, y: 4)
            let result = Transform.apply(t, to: p)
            #expect(result.x == 6)
            #expect(result.y == 8)
        }
        //
        @Test
        func `Scaling by zero collapses point`() {
            let t = Transform.scale(0)
            let p = Point2(x: 3, y: 4)
            let result = Transform.apply(t, to: p)
            #expect(result.x == 0)
            #expect(result.y == 0)
        }
        //
        @Test
        func `Negative scaling inverts coordinates`() {
            let t = Transform.scale(-1)
            let p = Point2(x: 3, y: 4)
            let result = Transform.apply(t, to: p)
            #expect(result.x == -3)
            #expect(result.y == -4)
        }
    }
    //
    // MARK: - Rotation Tests
    //
    @Suite
    struct `Rotation` {
        @Test
        func `Rotation by 90 degrees`() {
            let t = Transform.rotation(Degree(90))
            let p = Point2(x: 1, y: 0)
            let result = Transform.apply(t, to: p)
            #expect(isApprox(result.x, A.X(0)))
            #expect(isApprox(result.y, A.Y(1)))
        }
        //
        @Test
        func `Rotation by 180 degrees`() {
            let t = Transform.rotation(Degree(180))
            let p = Point2(x: 1, y: 0)
            let result = Transform.apply(t, to: p)
            #expect(isApprox(result.x, A.X(-1)))
            #expect(isApprox(result.y, A.Y(0)))
        }
        //
        @Test
        func `Rotation by 270 degrees`() {
            let t = Transform.rotation(Degree(270))
            let p = Point2(x: 1, y: 0)
            let result = Transform.apply(t, to: p)
            #expect(isApprox(result.x, A.X(0)))
            #expect(isApprox(result.y, A.Y(-1)))
        }
        //
        @Test(arguments: [
            (Point2(x: 3, y: 4), 45.0),
            (Point2(x: 1, y: 1), 90.0),
            (Point2(x: 5, y: 0), 180.0),
        ])
        func `Rotation preserves distance`(p: Point2, degrees: Double) {
            let t = Transform.rotation(Degree(degrees))
            let result = Transform.apply(t, to: p)
            let originalDist = p.distance(to: .zero)
            let resultDist = result.distance(to: .zero)
            #expect(abs(originalDist - resultDist) < 1e-10)
        }
    }
    //
    // MARK: - Composition Tests
    //
    @Suite
    struct `Composition` {
        @Test
        func `Concatenation order (scale then translate)`() {
            let scale = Transform.scale(2)
            let translate = Transform.translation(dx: 10, dy: 0)
            let combined = Transform.concatenating(translate, scale)
            //
            let p = Point2(x: 1, y: 0)
            let result = Transform.apply(combined, to: p)
            // scale: (1,0) -> (2,0), translate: (2,0) -> (12,0)
            #expect(result.x == 12)
            #expect(result.y == 0)
        }
        //
        @Test
        func `Concatenation instance method`() {
            let scale = Transform.scale(2)
            let translate = Transform.translation(dx: 10, dy: 0)
            let combined = translate.concatenating(scale)
            //
            let p = Point2(x: 1, y: 0)
            let result = combined.apply(to: p)
            #expect(result.x == 12)
            #expect(result.y == 0)
        }
        //
        @Test
        func `Compose multiple transforms`() {
            let composed = Transform.composed(
                .translation(dx: 1, dy: 0),
                .scale(2),
                .translation(dx: 0, dy: 1)
            )
            let p = Point2(x: 0, y: 0)
            let result = Transform.apply(composed, to: p)
            #expect(result.x == 1)
            #expect(result.y == 2)
        }
        //
        @Test
        func `Compose from array`() {
            let transforms = [
                Transform.translation(dx: 1, dy: 0),
                Transform.scale(2),
                Transform.translation(dx: 0, dy: 1),
            ]
            let composed = Transform.composed(transforms)
            let p = Point2(x: 0, y: 0)
            let result = Transform.apply(composed, to: p)
            #expect(result.x == 1)
            #expect(result.y == 2)
        }
        //
        @Test
        func `Identity is neutral for composition`() {
            let t = Transform.translation(dx: 5, dy: 10)
            let composed1 = Transform.concatenating(t, .identity)
            let composed2 = Transform.concatenating(.identity, t)
            //
            let p = Point2(x: 1, y: 1)
            let result1 = Transform.apply(composed1, to: p)
            let result2 = Transform.apply(composed2, to: p)
            //
            #expect(result1.x == 6)
            #expect(result1.y == 11)
            #expect(result2.x == 6)
            #expect(result2.y == 11)
        }
    }
    //
    // MARK: - Inversion Tests
    //
    @Suite
    struct `Inversion` {
        @Test
        func `Determinant of identity`() {
            let t = Transform.identity
            #expect(t.determinant == 1)
        }
        //
        @Test
        func `Identity is invertible`() {
            let t = Transform.identity
            #expect(t.isInvertible)
        }
        //
        @Test
        func `Singular transform is not invertible`() {
            let singular = Transform(a: 1.0, b: 2.0, c: 2.0, d: 4.0, tx: 0.0, ty: 0.0)
            #expect(!singular.isInvertible)
        }
        //
        @Test
        func `Invert translation`() {
            let t = Transform.translation(dx: 10, dy: 20)
            guard let inv = Transform.inverted(t) else {
                #expect(Bool(false), "Transform should be invertible")
                return
            }
            //
            let p = Point2(x: 1, y: 2)
            let transformed = Transform.apply(t, to: p)
            let restored = Transform.apply(inv, to: transformed)
            //
            #expect(isApprox(restored.x, p.x))
            #expect(isApprox(restored.y, p.y))
        }
        //
        @Test
        func `Invert scaling`() {
            let t = Transform.scale(2)
            guard let inv = Transform.inverted(t) else {
                #expect(Bool(false), "Transform should be invertible")
                return
            }
            //
            let p = Point2(x: 3, y: 4)
            let transformed = Transform.apply(t, to: p)
            let restored = Transform.apply(inv, to: transformed)
            //
            #expect(isApprox(restored.x, p.x))
            #expect(isApprox(restored.y, p.y))
        }
        //
        @Test
        func `Invert rotation`() {
            let t = Transform.rotation(Degree(45))
            guard let inv = Transform.inverted(t) else {
                #expect(Bool(false), "Transform should be invertible")
                return
            }
            //
            let p = Point2(x: 3, y: 4)
            let transformed = Transform.apply(t, to: p)
            let restored = Transform.apply(inv, to: transformed)
            //
            #expect(isApprox(restored.x, p.x))
            #expect(isApprox(restored.y, p.y))
        }
    }
    //
    // MARK: - Vector Transform Tests
    //
    @Suite
    struct `Vector Transform` {
        @Test
        func `Vector transform ignores translation`() {
            let t = Transform.translation(dx: 100, dy: 200).scaled(by: 2)
            let v = Vec2(dx: 3, dy: 4)
            let result = Transform.apply(t, to: v)
            // Translation should be ignored, only scaling applies
            #expect(result.dx == 6)
            #expect(result.dy == 8)
        }
        //
        @Test
        func `Identity preserves vectors`() {
            let v = Vec2(dx: 3, dy: 4)
            let result = Transform.apply(.identity, to: v)
            #expect(result.dx == 3)
            #expect(result.dy == 4)
        }
        //
        @Test
        func `Rotation transforms vectors`() {
            let t = Transform.rotation(Degree(90))
            let v = Vec2(dx: 1, dy: 0)
            let result = Transform.apply(t, to: v)
            #expect(isApprox(result.dx, L.Dx(0)))
            #expect(isApprox(result.dy, L.Dy(1)))
        }
    }
    //
    // MARK: - Equatable Tests
    //
    @Suite
    struct `Equatable` {
        @Test
        func `Transform equality`() {
            let a = Transform.translation(dx: 1, dy: 2)
            let b = Transform.translation(dx: 1, dy: 2)
            let c = Transform.translation(dx: 1, dy: 3)
            #expect(a == b)
            #expect(a != c)
        }
        //
        @Test
        func `Identity equals identity`() {
            #expect(Transform.identity == Transform.identity)
        }
        //
        @Test
        func `Different transforms are not equal`() {
            let scale = Transform.scale(2)
            let rotate = Transform.rotation(Degree(45))
            #expect(scale != rotate)
        }
    }
}
