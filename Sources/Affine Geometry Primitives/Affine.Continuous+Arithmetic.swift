import Affine_Primitives
import Linear_Primitives

extension Affine.Continuous.Point where Scalar: AdditiveArithmetic {

    @inlinable
    @_disfavoredOverload
    public static func - (
        lhs: borrowing Self,
        rhs: borrowing Self
    ) -> Linear<Scalar, Space>.Vector<N> {
        var result = InlineArray<N, Scalar>(repeating: lhs.coordinates[0] - rhs.coordinates[0])

        for i in 1..<N {
            result[i] = lhs.coordinates[i] - rhs.coordinates[i]
        }
        return Linear<Scalar, Space>.Vector(result)
    }

    @inlinable
    @_disfavoredOverload
    public static func + (
        lhs: borrowing Self,
        rhs: borrowing Linear<Scalar, Space>.Vector<N>
    ) -> Self {
        var result = lhs.coordinates

        for i in 0..<N {
            result[i] = lhs.coordinates[i] + rhs.components[i]
        }
        return Self(result)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (
        lhs: borrowing Self,
        rhs: borrowing Linear<Scalar, Space>.Vector<N>
    ) -> Self {
        var result = lhs.coordinates

        for i in 0..<N {
            result[i] = lhs.coordinates[i] - rhs.components[i]
        }
        return Self(result)
    }
}
