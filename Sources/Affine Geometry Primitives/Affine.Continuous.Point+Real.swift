// Affine.Continuous.Point+Real.swift
// Polar coordinates and rotation for 2D points with Real scalar types.

import Affine_Primitives
import Algebra_Linear_Primitives
public import Dimension_Primitives
public import Real_Primitives

// MARK: - Numeric.Transcendental

extension Affine.Continuous.Point where N == 2, Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// Creates point at polar coordinates relative to origin.
    @inlinable
    public static func polar(radius: Affine.Distance, angle: Radian<Scalar>) -> Self {
        let r = radius.rawValue
        return Self(
            x: Affine.X(r * angle.cos.value),
            y: Affine.Y(r * angle.sin.value)
        )
    }

    /// Angular direction from origin to this point in radians.
    @inlinable
    public var angle: Radian<Scalar> {
        Radian(Scalar._atan2(y.rawValue, x.rawValue))
    }

    /// Distance from origin to this point.
    @inlinable
    public var radius: Affine.Distance {
        Affine.Distance(Scalar._sqrt(x.rawValue * x.rawValue + y.rawValue * y.rawValue))
    }

    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>) -> Self {
        let c = angle.cos.value
        let s = angle.sin.value
        let px = point.x.rawValue
        let py = point.y.rawValue
        return Self(x: Affine.X(px * c - py * s), y: Affine.Y(px * s + py * c))
    }

    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates point counterclockwise around specified center by angle.
    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>, around center: Self) -> Self {
        let dx = point.x - center.x
        let dy = point.y - center.y
        let translated = Self(x: Affine.X.zero + dx, y: Affine.Y.zero + dy)
        let rotated = Self.rotated(translated, by: angle)
        let rdx = rotated.x - Affine.X.zero
        let rdy = rotated.y - Affine.Y.zero
        return Self(x: center.x + rdx, y: center.y + rdy)
    }

    /// Rotates point counterclockwise around specified center by angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }

    /// Rotates point counterclockwise around origin by angle in degrees.
    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>) -> Self {
        rotated(point, by: angle.radians)
    }

    /// Rotates point counterclockwise around origin by angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates point counterclockwise around specified center by angle in degrees.
    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>, around center: Self) -> Self {
        rotated(point, by: angle.radians, around: center)
    }

    /// Rotates point counterclockwise around specified center by angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }
}
