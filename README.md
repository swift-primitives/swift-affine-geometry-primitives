# swift-affine-geometry-primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Affine-space geometry types — N-dimensional points, translations, and 2D affine transforms parameterized by scalar type and a phantom coordinate space that keeps absolute positions distinct from displacement vectors.

---

## Key Features

- **Phantom coordinate spaces** — `Affine.Continuous<Scalar, Space>` tags every point and vector with a `Space` type, so coordinates from different coordinate systems are type-incompatible and cannot be mixed by accident.
- **Position vs. displacement, enforced by the algebra** — `Point` is an absolute position and `Linear.Vector` a displacement; `point - point` yields a vector, `point + vector` yields a point, and `point + point` has no operator because it has no affine meaning.
- **Compile-time dimensions** — `Point<N>` stores coordinates in an `InlineArray<N, Scalar>`, with `Point2` / `Point3` / `Point4` aliases and dimension-specific `x` / `y` / `z` / `w` accessors.
- **Typed coordinates and magnitudes** — position coordinates (`X` / `Y` / `Z` / `W`), displacement components (`Dx` / `Dy` / `Dz`), and `Distance` / `Area` are distinct types that all carry the coordinate space.
- **2D affine transforms** — `Transform` pairs a 2×2 linear matrix with a translation, with factory methods for `rotation`, `scale`, `shear`, and `translation`, fluent `rotated` / `scaled` / `translated`, plus `concatenating`, `inverted`, and `apply(to:)` for points and vectors.
- **Geometry operations** — displacement, distance and squared distance, `midpoint`, `lerp`, polar construction, and rotation around an arbitrary center.
- **Generic over the scalar** — richer operations unlock as the scalar conforms to `FloatingPoint` and transcendental protocols; conditional `Equatable`, `Hashable`, `Sendable`, and `Codable` (outside Embedded).

---

## Quick Start

The `Space` parameter is a phantom tag carried through every operation. Points and vectors in one coordinate space never silently combine with another, and the point/vector distinction is encoded in which operators exist:

```swift
import Affine_Geometry_Primitives

// A phantom coordinate space; points tagged with it are type-incompatible
// with points in any other space, caught at compile time.
enum Screen {}
typealias Pixel = Affine.Continuous<Double, Screen>

let cursor = Pixel.Point<2>(x: 0, y: 0)
let target = Pixel.Point<2>(x: 3, y: 4)

let offset = cursor.vector(to: target)    // Linear<Double, Screen>.Vector<2> — a displacement
let reach  = cursor.distance(to: target)  // 5.0, in Screen units
let middle = cursor.midpoint(to: target)  // Pixel.Point<2> at (1.5, 2.0)

let moved = target + offset               // Point + Vector = Point
// let nonsense = cursor + target         // error: Point + Point has no affine meaning
```

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-affine-geometry-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Affine Geometry Primitives", package: "swift-affine-geometry-primitives")
    ]
)
```

Requires Swift 6.3.1; minimum deployment targets macOS 26, iOS 26, tvOS 26, watchOS 26, visionOS 26.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
