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

In Xcode:

1. Add CoreText.framework dependency
2. Import the FieldKit.framework to your project
  2.1. Add '-ObjC' to "Other Linker Flags" (in order to load categories)
  2.2. Add FieldKit.framework
  2.3. Add FieldKit.bundle
  
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

__Overview:__

A FieldKit overview example with all fields presented inside a *UIScrollView*.

* FKTextField
* FKTokenField
* FKScrollField

__Color Tokens:__

A *FKTokenField* example, using *UIColor* instances as represented objects. The provided TokenFieldCell is subclassed. The background color and display string are derived from the UIColor.

__Message Composer:__

A composer view similar to the iOS *Messages* application. 

__Mail Composer:__

A composer view similar to the iOS *Mail* application.

__Keywords:__

TODO

## Roadmap

* Full iPad support (not tested)
* ARC support
* iOS 7 UI
