import Affine_Primitives
public import Dimension_Primitives
import Linear_Primitives
import Real_Primitives

extension Affine.Continuous.Point
where N == 2, Scalar: BinaryFloatingPoint & Numeric.Transcendental {

    @inlinable
    public static func polar(
        radius: Affine.Continuous<Scalar, Space>.Distance,
        angle: Radian<Scalar>
    ) -> Self {
        Self.zero.translated(by: Linear<Scalar, Space>.Vector.polar(length: radius, angle: angle))
    }

    @inlinable
    public var angle: Radian<Scalar> {
        Self.vector(from: .zero, to: self).angle
    }

    @inlinable
    public var radius: Affine.Continuous<Scalar, Space>.Distance {
        Self.distance.from(self, to: .zero)
    }

    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>, around center: Self) -> Self
    {
        center.translated(by: Self.vector(from: center, to: point).rotated(by: angle))
    }

    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>) -> Self {
        rotated(point, by: angle, around: .zero)
    }

    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    @inlinable
    public func rotated(by angle: Radian<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }

    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>, around center: Self) -> Self
    {
        rotated(point, by: angle.radians, around: center)
    }

    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>) -> Self {
        rotated(point, by: angle.radians)
    }

    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    @inlinable
    public func rotated(by angle: Degree<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }
}
