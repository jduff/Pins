# Pins
Simple API for Auto Layout interfaces.

## Setup

### Carthage
1. Add the jduff/Pins project to your Cartfile.
```
github "jduff/Pins"
```
2. Run `carthage update`, then [add the framework into your project](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
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
nestedView.pin(.top, to: mainView, padding: 10) // same as above
```

## TODO
- Support macOS and watchOS targets
