import Affine_Primitives
public import Dimension_Primitives
public import Linear_Primitives

extension Affine.Continuous {

    public struct Point<let N: Int> {

        public var coordinates: InlineArray<N, Scalar>

        @inlinable
        public init(_ coordinates: consuming InlineArray<N, Scalar>) {
            self.coordinates = coordinates
        }
    }
}

extension Affine.Continuous.Point: Sendable where Scalar: Sendable {}

extension Affine.Continuous.Point: Equatable where Scalar: Equatable {

    @inlinable
    public static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        for i in 0..<N {
            if lhs.coordinates[i] != rhs.coordinates[i] {
                return false
            }
        }
        return true
    }
}

extension Affine.Continuous.Point: Hashable where Scalar: Hashable {

    @inlinable
    public func hash(into hasher: inout Hasher) {
        (0..<N).forEach { i in
            hasher.combine(coordinates[i])
        }
    }
}

extension Affine.Continuous {

    public typealias Point2 = Point<2>

    public typealias Point3 = Point<3>

    public typealias Point4 = Point<4>
}

#if !hasFeature(Embedded)
    extension Affine.Continuous.Point: Codable where Scalar: Codable {

        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var coordinates = InlineArray<N, Scalar>(repeating: try container.decode(Scalar.self))
            for i in 1..<N {
                coordinates[i] = try container.decode(Scalar.self)
            }
            self.coordinates = coordinates
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            for i in 0..<N {
                try container.encode(coordinates[i])
            }
        }
    }
#endif

extension Affine.Continuous.Point {

    @inlinable
    public subscript(index: Int) -> Scalar {
        get { coordinates[index] }
        set { coordinates[index] = newValue }
    }
}

extension Affine.Continuous.Point {

    @inlinable
    public init<U, E: Swift.Error>(
        _ other: borrowing Affine.Continuous<U, Space>.Point<N>,
        _ transform: (U) throws(E) -> Scalar
    ) throws(E) {
        var coords = InlineArray<N, Scalar>(repeating: try transform(other.coordinates[0]))
        for i in 1..<N {
            coords[i] = try transform(other.coordinates[i])
        }
        self.init(coords)
    }

    @inlinable
    public func map<Result, E: Swift.Error>(
        _ transform: (Scalar) throws(E) -> Result
    ) throws(E) -> Affine.Continuous<Result, Space>.Point<N> {
        var result = InlineArray<N, Result>(repeating: try transform(coordinates[0]))
        for i in 1..<N {
            result[i] = try transform(coordinates[i])
        }
        return Affine.Continuous<Result, Space>.Point<N>(result)
    }
}

extension Affine.Continuous.Point where Scalar: AdditiveArithmetic {

    @inlinable
    public static var zero: Self {
        Self(InlineArray(repeating: .zero))
    }
}

extension Affine.Continuous.Point where N == 2 {

    @inlinable
    public var x: Affine.Continuous<Scalar, Space>.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue.underlying }
    }

    @inlinable
    public var y: Affine.Continuous<Scalar, Space>.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue.underlying }
    }

    @inlinable
    public init(x: Affine.Continuous<Scalar, Space>.X, y: Affine.Continuous<Scalar, Space>.Y) {
        self.init([x.underlying, y.underlying])
    }
}

extension Affine.Continuous.Point where N == 3 {

    @inlinable
    public var x: Affine.Continuous<Scalar, Space>.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue.underlying }
    }

    @inlinable
    public var y: Affine.Continuous<Scalar, Space>.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue.underlying }
    }

    @inlinable
    public var z: Affine.Continuous<Scalar, Space>.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue.underlying }
    }

    @inlinable
    public init(
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y,
        z: Affine.Continuous<Scalar, Space>.Z
    ) {
        self.init([x.underlying, y.underlying, z.underlying])
    }

    @inlinable
    public init(
        _ point2: Affine.Continuous<Scalar, Space>.Point2,
        z: Affine.Continuous<Scalar, Space>.Z
    ) {
        self.init(x: point2.x, y: point2.y, z: z)
    }
}

extension Affine.Continuous.Point where N == 4 {

    @inlinable
    public var x: Affine.Continuous<Scalar, Space>.X {
        get { .init(coordinates[0]) }
        set { coordinates[0] = newValue.underlying }
    }

    @inlinable
    public var y: Affine.Continuous<Scalar, Space>.Y {
        get { .init(coordinates[1]) }
        set { coordinates[1] = newValue.underlying }
    }

    @inlinable
    public var z: Affine.Continuous<Scalar, Space>.Z {
        get { .init(coordinates[2]) }
        set { coordinates[2] = newValue.underlying }
    }

    @inlinable
    public var w: Affine.Continuous<Scalar, Space>.W {
        get { .init(coordinates[3]) }
        set { coordinates[3] = newValue.underlying }
    }

    @inlinable
    public init(
        x: Affine.Continuous<Scalar, Space>.X,
        y: Affine.Continuous<Scalar, Space>.Y,
        z: Affine.Continuous<Scalar, Space>.Z,
        w: Affine.Continuous<Scalar, Space>.W
    ) {
        self.init([x.underlying, y.underlying, z.underlying, w.underlying])
    }

    @inlinable
    public init(
        _ point3: Affine.Continuous<Scalar, Space>.Point3,
        w: Affine.Continuous<Scalar, Space>.W
    ) {
        self.init(x: point3.x, y: point3.y, z: point3.z, w: w)
    }
}

extension Affine.Continuous.Point {

    @inlinable
    public static func zip(_ a: Self, _ b: Self, _ combine: (Scalar, Scalar) -> Scalar) -> Self {
        var result = a.coordinates
        (0..<N).forEach { i in
            result[i] = combine(a.coordinates[i], b.coordinates[i])
        }
        return Self(result)
    }
}

extension Affine.Continuous.Point where N == 2, Scalar: AdditiveArithmetic {

    @inlinable
    public static func translated(
        _ point: Self,
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy
    ) -> Self {
        Self(x: point.x + dx, y: point.y + dy)
    }

    @inlinable
    public func translated(dx: Linear<Scalar, Space>.Dx, dy: Linear<Scalar, Space>.Dy) -> Self {
        Self.translated(self, dx: dx, dy: dy)
    }

    @inlinable
    public static func translated(_ point: Self, by vector: Linear<Scalar, Space>.Vector<2>) -> Self
    {
        Self(x: point.x + vector.dx, y: point.y + vector.dy)
    }

    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<2>) -> Self {
        Self.translated(self, by: vector)
    }

    @inlinable
    public static func vector(from point: Self, to other: Self) -> Linear<Scalar, Space>.Vector<2> {
        Linear<Scalar, Space>.Vector(dx: other.x - point.x, dy: other.y - point.y)
    }

    @inlinable
    public func vector(to other: Self) -> Linear<Scalar, Space>.Vector<2> {
        Self.vector(from: self, to: other)
    }
}

extension Affine.Continuous.Point where N == 2, Scalar: FloatingPoint {

    @inlinable
    public static func lerp(from point: Self, to other: Self, t: Scale<1, Scalar>) -> Self {
        Self(
            x: point.x + t * (other.x - point.x),
            y: point.y + t * (other.y - point.y)
        )
    }

    @inlinable
    public func lerp(to other: Self, t: Scale<1, Scalar>) -> Self {
        Self.lerp(from: self, to: other, t: t)
    }

    @inlinable
    public static func midpoint(from point: Self, to other: Self) -> Self {

        Self(
            x: point.x + (other.x - point.x) / 2,
            y: point.y + (other.y - point.y) / 2
        )
    }

    @inlinable
    public func midpoint(to other: Self) -> Self {
        Self.midpoint(from: self, to: other)
    }
}

extension Affine.Continuous.Point where N == 2, Scalar: FloatingPoint {

    public static var distance: Affine.Continuous<Scalar, Space>.Point<2>.Distance2.Type {
        Affine.Continuous<Scalar, Space>.Point<2>.Distance2.self
    }

    public var distance: Affine.Continuous<Scalar, Space>.Point<2>.Distance2 {
        .init(point: self)
    }

    public struct Distance2 {
        var point: Affine.Continuous<Scalar, Space>.Point<2>
    }
}

extension Affine.Continuous.Point.Distance2 where N == 2, Scalar: FloatingPoint {

    public static func squared(
        from point: Affine.Continuous<Scalar, Space>.Point<2>,
        to other: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Area {
        let dx = other.x - point.x
        let dy = other.y - point.y
        return dx * dx + dy * dy
    }

    public func squared(
        to other: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Area {
        Self.squared(from: point, to: other)
    }

    public static func from(
        _ point: Affine.Continuous<Scalar, Space>.Point<2>,
        to other: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Distance {

        sqrt(squared(from: point, to: other))
    }

    public func callAsFunction(
        to other: Affine.Continuous<Scalar, Space>.Point<2>
    ) -> Affine.Continuous<Scalar, Space>.Distance {
        Self.from(point, to: other)
    }
}

extension Affine.Continuous.Point where N == 3, Scalar: AdditiveArithmetic {

    @inlinable
    public static func translated(
        _ point: Self,
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy,
        dz: Linear<Scalar, Space>.Dz
    ) -> Self {
        Self(x: point.x + dx, y: point.y + dy, z: point.z + dz)
    }

    @inlinable
    public func translated(
        dx: Linear<Scalar, Space>.Dx,
        dy: Linear<Scalar, Space>.Dy,
        dz: Linear<Scalar, Space>.Dz
    ) -> Self {
        Self.translated(self, dx: dx, dy: dy, dz: dz)
    }

    @inlinable
    public static func translated(_ point: Self, by vector: Linear<Scalar, Space>.Vector<3>) -> Self
    {
        Self(x: point.x + vector.dx, y: point.y + vector.dy, z: point.z + vector.dz)
    }

    @inlinable
    public func translated(by vector: Linear<Scalar, Space>.Vector<3>) -> Self {
        Self.translated(self, by: vector)
    }

    @inlinable
    public static func vector(from point: Self, to other: Self) -> Linear<Scalar, Space>.Vector<3> {
        Linear<Scalar, Space>.Vector(
            dx: other.x - point.x,
            dy: other.y - point.y,
            dz: other.z - point.z
        )
    }

    @inlinable
    public func vector(to other: Self) -> Linear<Scalar, Space>.Vector<3> {
        Self.vector(from: self, to: other)
    }
}

extension Affine.Continuous.Point where N == 3, Scalar: FloatingPoint {

    public static var distance: Affine.Continuous<Scalar, Space>.Point<3>.Distance3.Type {
        Affine.Continuous<Scalar, Space>.Point<3>.Distance3.self
    }

    public var distance: Affine.Continuous<Scalar, Space>.Point<3>.Distance3 {
        .init(point: self)
    }

    public struct Distance3 {
        var point: Affine.Continuous<Scalar, Space>.Point<3>
    }
}

extension Affine.Continuous.Point.Distance3 where N == 3, Scalar: FloatingPoint {

    public static func squared(
        from point: Affine.Continuous<Scalar, Space>.Point<3>,
        to other: Affine.Continuous<Scalar, Space>.Point<3>
    ) -> Affine.Continuous<Scalar, Space>.Area {
        let dx = other.x - point.x
        let dy = other.y - point.y
        let dz = other.z - point.z
        return dx * dx + dy * dy + dz * dz
    }

    public func squared(
        to other: Affine.Continuous<Scalar, Space>.Point<3>
    ) -> Affine.Continuous<Scalar, Space>.Area {
        Self.squared(from: point, to: other)
    }

    public static func from(
        _ point: Affine.Continuous<Scalar, Space>.Point<3>,
        to other: Affine.Continuous<Scalar, Space>.Point<3>
    ) -> Affine.Continuous<Scalar, Space>.Distance {

        sqrt(squared(from: point, to: other))
    }

    public func callAsFunction(
        to other: Affine.Continuous<Scalar, Space>.Point<3>
    ) -> Affine.Continuous<Scalar, Space>.Distance {
        Self.from(point, to: other)
    }
}
