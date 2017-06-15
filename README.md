# Pins
Simple API for Auto Layout interfaces. Works with iOS and macOS.

## Setup

### Carthage
1. Add the jduff/Pins project to your `Cartfile`.
```
github "jduff/Pins"
```
2. Run `carthage update`, then [add the framework into your project](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
3. Import the Pins framework/module.
- Swift: `import Pins`

### Cocoapods
1. Add the following information to your `Podfile`.
```
use_frameworks!

target '<Your Target Name>' do
    pod 'Pins', '~> 1.0'
end
```
2. Run `pod install`
3. Import the Pins framework/module.
- Swift: `import Pins`

## Usage

``` swift
// Pin bounds, 4 constraints created and activated
nestedView.pin(leadingTo: mainView.leftAnchor, topTo: mainView.topAnchor, trailingTo: mainView.rightAnchor, bottomTo: mainView.bottomAnchor)
nestedView.pin(to: mainView) // same as above

// Pins are optional when it makes sense, 2 constraints created and activated
nestedView.pin(leadingTo: mainView.leftAnchor, topTo: nil, trailingTo: mainView.rightAnchor, bottomTo: nil)

// Pin height and width, 2 constraints created and activated
nestedView.pin(height: 20, width: 10)

// Pin top with padding, 1 constraint with constant of 10 created and activated
nestedView.pin(.top, to: mainView.topAnchor, padding: 10)
let topConstraint = nestedView.pin(.top, to: mainView, padding: 10) // same as above
```

- When you call `pin` on a `View` we set `translatesAutoresizingMaskIntoConstraints` to `false` so you don't need to.
- On the `NSLayoutConstraint` that is created we also set `isActive` to `true` so it's already activated for you.
- We return any `NSLayoutConstraint` objects that are created when you call `pin` so that you can reference them later or do anything else you might need.

## License

Pins is licensed under the MIT License. See the LICENSE file for more information.
