# FieldKit

## Introduction

FieldKit is a UI library of custom text fields for iOS:

* *FKTextField* is similar to UITextField
* *FKTokenField* is similar to NSTokenField in AppKit but adapted to iOS/Touch Interaction
* *FKScrollField* adds multiple lines and scrolling to *FKTextField*

## Requirements

* The iOS 5.0 SDK is needed to build. It can however run on iOS 4.1 or higher (iPhone/iPad universal app compatible).

* Suported devices: iPhone/iPad (*)
* Minimum iOS: 4.1
* Required Frameworks:
   * CoreText.framework
   * UIKit.framework

## How to use FieldKit in your project

### CocoaPods

1. Create or edit an existing text file named Podfile in your Xcode project directory:

```ruby
platform :ios, '5.1'

pod "FieldKit", '~> 0.1.4'
```

2. Install FieldKit in your project:

```bash
$ pod install
```

3. Open the Xcode workspace instead of the project file when building your project:

```bash
$ open YourProject.xcworkspace
```

4. Use FieldKit in your project:

```obj-c
#import <FieldKit/FieldKit.h>
```

### Framework

1. Open FieldKit.xcodeproj
2. Select the 'Framework' scheme
3. Build (this will build two products, 'FieldKit.framework' and 'FieldKit.bundle')
4. Import the FieldKit.framework to your project
5. Add '-ObjC' to *Other Linker Flag* in *Build Settings* target section (in order to load Objective-C class categories) 
6. Add FieldKit.framework to *Link Binary with Libraries* in *Build Phases* target section
7. Add FiekdKit.bundle to your project resources

You also need to add the following frameworks to your project:

* CoreText.framework
* CoreGraphics.framework
  
## Overview

FieldKit doesn't subclass the text fields provided by UIKit. The text input, selection and manipulation is implemented from scratch. It conforms to UITextInput like UITextField.

__FKTextField:__

* Prefix label (optional)
* Placeholder (optional)
* Single line

__FKTokenField:__

* Token view cells (UIControl)
* Object <-> token representation
* Possible applications: Could be used to pick values from predefined list (ie. address book, tags, keywords, email adresses, ...)

__FKScrollField:__

* Multiple lines
* Ability to expand frame beyond initial frame
* Delegate is notified about changes and can control growing behaviour
* Will enable scrolling if content doesn't fit frame

# Examples

## Overview

The *Overview* example shows how to use *FKTextField* and *FKTokenField*. The text field are presented inside a scroll view.

![FieldKit Overview Example Screenshot](https://raw.github.com/laugga/fieldkit/master/docs/figures/overview_example_screenshot.png "FieldKit Overview Example Screenshot")

## Color Tokens

A *FKTokenField* example, using *UIColor* instances as represented objects. The provided TokenFieldCell is subclassed. The background color and display string are derived from the UIColor.

## Mail Composer

A composer view similar to the iOS *Mail* application. (*work in progress*)

## Message Composer

TODO

## Keywords

TODO

## Roadmap

* Full iPad support (not tested)
* ARC support
* iOS 7 UI
