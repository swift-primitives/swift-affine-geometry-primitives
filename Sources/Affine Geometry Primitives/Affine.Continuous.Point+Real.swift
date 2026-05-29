// Affine.Continuous.Point+Real.swift
// Polar coordinates and rotation for 2D points with Real scalar types.

import Affine_Primitives
import Linear_Primitives
public import Dimension_Primitives
import Real_Primitives

// MARK: - Numeric.Transcendental

extension Affine.Continuous.Point where N == 2, Scalar: BinaryFloatingPoint & Numeric.Transcendental {

    // MARK: - Polar Coordinates

    /// Creates point at polar coordinates relative to origin.
    @inlinable
    public static func polar(radius: Affine.Continuous<Scalar, Space>.Distance, angle: Radian<Scalar>) -> Self {
        Self.zero.translated(by: Linear<Scalar, Space>.Vector.polar(length: radius, angle: angle))
    }

    /// Angular direction from origin to this point in radians.
    @inlinable
    public var angle: Radian<Scalar> {
        Self.vector(from: .zero, to: self).angle
    }

    /// Distance from origin to this point.
    @inlinable
    public var radius: Affine.Continuous<Scalar, Space>.Distance {
        Self.distance.from(self, to: .zero)
    }

    // MARK: - Rotation (Radian)

    /// Rotates point counterclockwise around center by specified angle.
    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>, around center: Self) -> Self {
        center.translated(by: Self.vector(from: center, to: point).rotated(by: angle))
    }

    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public static func rotated(_ point: Self, by angle: Radian<Scalar>) -> Self {
        rotated(point, by: angle, around: .zero)
    }

    /// Rotates point counterclockwise around origin by specified angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    /// Rotates point counterclockwise around center by specified angle.
    @inlinable
    public func rotated(by angle: Radian<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }

    // MARK: - Rotation (Degree)

    /// Rotates point counterclockwise around center by angle in degrees.
    @inlinable
    public static func rotated(_ point: Self, by angle: Degree<Scalar>, around center: Self) -> Self {
        rotated(point, by: angle.radians, around: center)
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

    /// Rotates point counterclockwise around center by angle in degrees.
    @inlinable
    public func rotated(by angle: Degree<Scalar>, around center: Self) -> Self {
        Self.rotated(self, by: angle, around: center)
    }
}
