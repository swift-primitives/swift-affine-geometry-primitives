// Affine.Continuous.Translation.swift
// A 2D translation (displacement) in an affine space.

import Affine_Primitives
public import Dimension_Primitives
public import Linear_Primitives

extension Affine.Continuous {
    /// Two-dimensional displacement in coordinate space.
    ///
    /// Represents directional offset rather than absolute position, distinguishing it from `Point`.
    /// Translation carries coordinate system units, unlike dimensionless transformations like rotation or scale.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let offset = Affine<Double>.Translation(dx: 72, dy: 144)
    /// let point = Affine<Double>.Point(x: 10, y: 20)
    /// let translated = point.translated(by: offset.vector)  // (82, 164)
    /// ```
    public struct Translation {
        /// Horizontal displacement component.
        public var dx: Linear<Scalar, Space>.Dx

        /// Vertical displacement component.
        public var dy: Linear<Scalar, Space>.Dy

        /// Creates translation from type-safe displacement components.
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

// MARK: - Convenience Initializers

extension Affine.Continuous.Translation {
    /// Creates translation from 2D displacement vector.
    @inlinable
    public init(_ vector: Linear<Scalar, Space>.Vector<2>) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
}

// MARK: - Zero

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {
    /// Identity translation with no displacement.
    @inlinable
    public static var zero: Self {
        Self(dx: .zero, dy: .zero)
    }
}

// MARK: - AdditiveArithmetic

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {
    /// Adds two translations component-wise.
    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    /// Subtracts two translations component-wise.
    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

// MARK: - Negation

extension Affine.Continuous.Translation where Scalar: SignedNumeric {
    /// Negates translation direction.
    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(dx: -value.dx, dy: -value.dy)
    }
}

// MARK: - Conversion to Vector

extension Affine.Continuous.Translation {
    /// Converts translation to 2D displacement vector.
    @inlinable
    public var vector: Linear<Scalar, Space>.Vector<2> {
        Linear<Scalar, Space>.Vector(dx: dx, dy: dy)
    }
}
