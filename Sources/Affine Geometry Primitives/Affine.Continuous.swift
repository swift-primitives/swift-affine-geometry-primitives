// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Affine_Primitives
public import Algebra_Linear_Primitives
public import Dimension_Primitives

/// Namespace for continuous affine space primitives parameterized by scalar type and coordinate space.
///
/// Affine spaces represent geometry where points have position but no canonical origin.
/// This differs from vector spaces which have a distinguished zero point.
/// The `Space` parameter is a phantom type that distinguishes points in different coordinate systems.
///
/// ## Example
///
/// ```swift
/// // Points in different coordinate spaces are type-incompatible
/// typealias UserPoint = Affine.Continuous<Double, UserSpace>.Point<2>
/// typealias DevicePoint = Affine.Continuous<Double, DeviceSpace>.Point<2>
///
/// let p = UserPoint(x: 1, y: 2)
/// let q = UserPoint(x: 4, y: 6)
/// let displacement = q - p  // Linear<Double, UserSpace>.Vector<2>
/// ```
extension Affine {
    public enum Continuous<Scalar: ~Copyable, Space>: ~Copyable {}
}

extension Affine.Continuous: Copyable where Scalar: Copyable {}
extension Affine.Continuous: Sendable where Scalar: Sendable {}

// MARK: - Coordinate Type Aliases

extension Affine.Continuous {
    /// Type-safe horizontal coordinate representing absolute position on the x-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias X = Coordinate.X<Space>.Value<Scalar>

    /// Type-safe vertical coordinate representing absolute position on the y-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Y = Coordinate.Y<Space>.Value<Scalar>

    /// Type-safe depth coordinate representing absolute position on the z-axis,
    /// parameterized by coordinate space.
    ///
    /// Distinguishes position coordinates from displacement vectors for type safety.
    public typealias Z = Coordinate.Z<Space>.Value<Scalar>

    /// Type-safe homogeneous coordinate for projective transformations,
    /// parameterized by coordinate space.
    ///
    /// Used in 4D homogeneous coordinates where `w=1` represents standard 3D points.
    public typealias W = Coordinate.W<Space>.Value<Scalar>
}

// MARK: - Displacement Type Aliases

extension Affine.Continuous {
    /// Horizontal displacement component.
    ///
    /// See ``Linear/Dx``
    public typealias Dx = Linear<Scalar, Space>.Dx

    /// Vertical displacement component.
    ///
    /// See ``Linear/Dy``
    public typealias Dy = Linear<Scalar, Space>.Dy

    /// Depth displacement component.
    ///
    /// See ``Linear/Dz``
    public typealias Dz = Linear<Scalar, Space>.Dz
}

// MARK: - Magnitude Type Aliases

extension Affine.Continuous {
    /// Distance between two points (non-directional magnitude).
    ///
    /// See ``Dimension/Distance``
    public typealias Distance = Dimension_Primitives.Distance<Space, Scalar>

    /// Squared distance / area measure in this coordinate space.
    ///
    /// See ``Dimension/Area``
    public typealias Area = Dimension_Primitives.Area<Space>.Value<Scalar>
}
