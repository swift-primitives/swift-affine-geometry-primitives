import Affine_Primitives
public import Dimension_Primitives
public import Linear_Primitives

extension Affine.Continuous {

    public struct Translation {

        public var dx: Linear<Scalar, Space>.Dx

        public var dy: Linear<Scalar, Space>.Dy

        @inlinable
        public init(dx: Linear<Scalar, Space>.Dx, dy: Linear<Scalar, Space>.Dy) {
            self.dx = dx
            self.dy = dy
        }
    }
}

extension Affine.Continuous.Translation: Sendable where Scalar: Sendable {}
extension Affine.Continuous.Translation: Equatable where Scalar: Equatable {}
extension Affine.Continuous.Translation: Hashable where Scalar: Hashable {}

#if !hasFeature(Embedded)
    extension Affine.Continuous.Translation: Codable where Scalar: Codable {}
#endif

extension Affine.Continuous.Translation {

    @inlinable
    public init(_ vector: Linear<Scalar, Space>.Vector<2>) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
}

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {

    @inlinable
    public static var zero: Self {
        Self(dx: .zero, dy: .zero)
    }
}

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

extension Affine.Continuous.Translation where Scalar: SignedNumeric {

    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(dx: -value.dx, dy: -value.dy)
    }
}

extension Affine.Continuous.Translation {

    @inlinable
    public var vector: Linear<Scalar, Space>.Vector<2> {
        Linear<Scalar, Space>.Vector(dx: dx, dy: dy)
    }
}
