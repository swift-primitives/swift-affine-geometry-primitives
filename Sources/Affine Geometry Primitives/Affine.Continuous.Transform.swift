import Affine_Primitives
public import Dimension_Primitives
public import Linear_Primitives
public import Real_Primitives

extension Affine.Continuous {

    public struct Transform {

        public var linear: Linear<Scalar, Space>.Matrix<2, 2>

        public var translation: Translation

        @inlinable
        public init(linear: Linear<Scalar, Space>.Matrix<2, 2>, translation: Translation) {
            self.linear = linear
            self.translation = translation
        }
    }
}

extension Affine.Continuous.Transform: Sendable where Scalar: Sendable {}
extension Affine.Continuous.Transform: Equatable where Scalar: Equatable {}
extension Affine.Continuous.Transform: Hashable where Scalar: Hashable {}

#if !hasFeature(Embedded)
    extension Affine.Continuous.Transform: Codable where Scalar: Codable, Scalar: FloatingPoint {
        private enum CodingKeys: String, CodingKey {
            case a, b, c, d, tx, ty
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let a = try container.decode(Scalar.self, forKey: .a)
            let b = try container.decode(Scalar.self, forKey: .b)
            let c = try container.decode(Scalar.self, forKey: .c)
            let d = try container.decode(Scalar.self, forKey: .d)
            let tx = try container.decode(Linear<Scalar, Space>.Dx.self, forKey: .tx)
            let ty = try container.decode(Linear<Scalar, Space>.Dy.self, forKey: .ty)
            self.init(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(a, forKey: .a)
            try container.encode(b, forKey: .b)
            try container.encode(c, forKey: .c)
            try container.encode(d, forKey: .d)
            try container.encode(tx.underlying, forKey: .tx)
            try container.encode(ty.underlying, forKey: .ty)
        }
    }
#endif

extension Affine.Continuous.Transform
where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {

    @inlinable
    public static var identity: Self {
        Self(linear: .identity, translation: .zero)
    }
}

extension Affine.Continuous.Transform where Scalar: AdditiveArithmetic {

    @inlinable
    public init(linear: Linear<Scalar, Space>.Matrix<2, 2>) {
        self.init(linear: linear, translation: .zero)
    }
}

extension Affine.Continuous.Transform
where Scalar: AdditiveArithmetic & ExpressibleByIntegerLiteral {

    @inlinable
    public init(translation: Affine.Continuous<Scalar, Space>.Translation) {
        self.init(linear: .identity, translation: translation)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint {

    @inlinable
    public var a: Scale<1, Scalar> {
        get { Scale(linear.a) }
        set { linear.a = newValue.value }
    }

    @inlinable
    public var b: Scale<1, Scalar> {
        get { Scale(linear.b) }
        set { linear.b = newValue.value }
    }

    @inlinable
    public var c: Scale<1, Scalar> {
        get { Scale(linear.c) }
        set { linear.c = newValue.value }
    }

    @inlinable
    public var d: Scale<1, Scalar> {
        get { Scale(linear.d) }
        set { linear.d = newValue.value }
    }
}

extension Affine.Continuous.Transform {

    @inlinable
    public var tx: Linear<Scalar, Space>.Dx {
        get { translation.dx }
        set { translation.dx = newValue }
    }

    @inlinable
    public var ty: Linear<Scalar, Space>.Dy {
        get { translation.dy }
        set { translation.dy = newValue }
    }
}

extension Affine.Continuous.Transform {

    @inlinable
    public init(
        a: Scalar,
        b: Scalar,
        c: Scalar,
        d: Scalar,
        tx: Linear<Scalar, Space>.Dx,
        ty: Linear<Scalar, Space>.Dy
    ) {
        self.linear = Linear<Scalar, Space>.Matrix(a: a, b: b, c: c, d: d)
        self.translation = Affine.Continuous<Scalar, Space>.Translation(dx: tx, dy: ty)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint {

    @inlinable
    public static func concatenating(_ transform: Self, _ other: Self) -> Self {

        let newLinear = transform.linear.multiplied(by: other.linear)

        let otherTx = other.translation.dx.underlying
        let otherTy = other.translation.dy.underlying
        let selfTx = transform.translation.dx.underlying
        let selfTy = transform.translation.dy.underlying

        let newTxValue = transform.linear.a * otherTx + transform.linear.b * otherTy + selfTx
        let newTyValue = transform.linear.c * otherTx + transform.linear.d * otherTy + selfTy

        return Self(
            linear: newLinear,
            translation: Affine.Continuous<Scalar, Space>.Translation(
                dx: .init(newTxValue),
                dy: .init(newTyValue)
            )
        )
    }

    @inlinable
    public func concatenating(_ other: Self) -> Self {
        Self.concatenating(self, other)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {

    @inlinable
    public static func translation(
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy
    ) -> Self {
        Self(
            linear: .identity,
            translation: Affine.Continuous<Scalar, Space>.Translation(dx: dx, dy: dy)
        )
    }

    @inlinable
    public static func translation(_ vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self(translation: Affine.Continuous<Scalar, Space>.Translation(vector))
    }

    @inlinable
    public static func translation(
        _ translation: Affine.Continuous<Scalar, Space>.Translation
    ) -> Self {
        Self(linear: .identity, translation: translation)
    }

    @inlinable
    public static func scale(_ factor: Scale<1, Scalar>) -> Self {
        Self(linear: Linear<Scalar, Space>.Matrix(a: factor.value, b: 0, c: 0, d: factor.value))
    }

    @inlinable
    public static func scale(
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y
    ) -> Self {
        Self(
            linear: Linear<Scalar, Space>.Matrix(
                a: x.underlying,
                b: 0,
                c: 0,
                d: y.underlying
            )
        )
    }

    @inlinable
    public static func shear(
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y
    ) -> Self {
        Self(linear: Linear<Scalar, Space>.Matrix(a: 1, b: x.underlying, c: y.underlying, d: 1))
    }
}

extension Affine.Continuous.Transform where Scalar == Double {

    @inlinable
    public static func rotation(_ angle: Radian<Scalar>) -> Self {
        Self(
            linear: Linear<Scalar, Space>.Matrix.rotation(
                cos: angle.cos.value,
                sin: angle.sin.value
            ),
            translation: .zero
        )
    }

    @inlinable
    public static func rotation(_ angle: Degree<Scalar>) -> Self {
        rotation(angle.radians)
    }
}

extension Affine.Continuous.Transform where Scalar == Float {

    @inlinable
    public static func rotation(_ angle: Radian<Scalar>) -> Self {
        Self(
            linear: Linear<Scalar, Space>.Matrix.rotation(
                cos: angle.cos.value,
                sin: angle.sin.value
            ),
            translation: .zero
        )
    }

    @inlinable
    public static func rotation(_ angle: Degree<Scalar>) -> Self {
        rotation(angle.radians)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {

    @inlinable
    public static func translated(
        _ transform: Self,
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy
    ) -> Self {
        concatenating(transform, .translation(dx: dx, dy: dy))
    }

    @inlinable
    public func translated(dx: Linear<Scalar, Space>.Dx, dy: Linear<Scalar, Space>.Dy) -> Self {
        Self.translated(self, dx: dx, dy: dy)
    }

    @inlinable
    public static func translated(
        _ transform: Self,
        by vector: Linear<Scalar, Space>.Vector<2>
    ) -> Self {
        concatenating(transform, .translation(vector))
    }

    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self.translated(self, by: vector)
    }

    @inlinable
    public static func translated(
        _ transform: Self,
        by translation: Affine.Continuous<Scalar, Space>.Translation
    ) -> Self {
        concatenating(transform, .translation(translation))
    }

    @inlinable
    public func translated(by translation: Affine.Continuous<Scalar, Space>.Translation) -> Self {
        Self.translated(self, by: translation)
    }

    @inlinable
    public static func scaled(_ transform: Self, by factor: Scale<1, Scalar>) -> Self {
        concatenating(transform, .scale(factor))
    }

    @inlinable
    public func scaled(by factor: Scale<1, Scalar>) -> Self {
        Self.scaled(self, by: factor)
    }

    @inlinable
    public static func scaled(
        _ transform: Self,
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y
    ) -> Self {
        concatenating(transform, .scale(x: x, y: y))
    }

    @inlinable
    public func scaled(
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y
    ) -> Self {
        Self.scaled(self, x: x, y: y)
    }
}

extension Affine.Continuous.Transform where Scalar == Double {

    @inlinable
    public static func rotated(_ transform: Self, by angle: Radian<Scalar>) -> Self {
        concatenating(transform, .rotation(angle))
    }

    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    @inlinable
    public static func rotated(_ transform: Self, by angle: Degree<Scalar>) -> Self {
        concatenating(transform, .rotation(angle))
    }

    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }
}

extension Affine.Continuous.Transform where Scalar == Float {

    @inlinable
    public static func rotated(_ transform: Self, by angle: Radian<Scalar>) -> Self {
        concatenating(transform, .rotation(angle))
    }

    @inlinable
    public func rotated(by angle: Radian<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }

    @inlinable
    public static func rotated(_ transform: Self, by angle: Degree<Scalar>) -> Self {
        concatenating(transform, .rotation(angle))
    }

    @inlinable
    public func rotated(by angle: Degree<Scalar>) -> Self {
        Self.rotated(self, by: angle)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint {

    @inlinable
    public var determinant: Scalar {
        linear.determinant
    }

    @inlinable
    public var isInvertible: Bool {
        determinant != 0
    }

    @inlinable
    public static func inverted(_ transform: Self) -> Self? {
        guard let invLinear = transform.linear.inverse else { return nil }

        let negatedTranslation = -(invLinear * transform.translation.vector)

        return Self(
            linear: invLinear,
            translation: Affine.Continuous<Scalar, Space>.Translation(negatedTranslation)
        )
    }

    @inlinable
    public var inverted: Self? {
        Self.inverted(self)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint {

    @inlinable
    public static func apply(
        _ transform: Self,
        to point: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Point<2> {

        let px = point.x.underlying
        let py = point.y.underlying
        let newX =
            transform.linear.a * px + transform.linear.b * py + transform.translation.dx.underlying
        let newY =
            transform.linear.c * px + transform.linear.d * py + transform.translation.dy.underlying
        return Affine.Continuous<Scalar, Space>.Point(x: .init(newX), y: .init(newY))
    }

    @inlinable
    public func apply(
        to point: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Point<2> {
        Self.apply(self, to: point)
    }

    @inlinable
    public static func apply(
        _ transform: Self,
        to vector: Linear<Scalar, Space>.Vector<2>
    ) -> Linear<Scalar, Space>.Vector<2> {

        let vx = vector.dx.underlying
        let vy = vector.dy.underlying
        let newDx = transform.linear.a * vx + transform.linear.b * vy
        let newDy = transform.linear.c * vx + transform.linear.d * vy
        return Linear<Scalar, Space>.Vector(dx: .init(newDx), dy: .init(newDy))
    }

    @inlinable
    public func apply(to vector: Linear<Scalar, Space>.Vector<2>) -> Linear<Scalar, Space>.Vector<2>
    {
        Self.apply(self, to: vector)
    }
}

extension Affine.Continuous.Transform where Scalar: FloatingPoint & ExpressibleByIntegerLiteral {

    @inlinable
    public static func composed(_ transforms: [Self]) -> Self {
        transforms.reduce(.identity) { $0.concatenating($1) }
    }

    @inlinable
    public static func composed(_ transforms: Self...) -> Self {
        composed(transforms)
    }
}
