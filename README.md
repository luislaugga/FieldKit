FieldKit
========

Introduction
------------

FieldKit contains a set of custom text fields for iOS:

* *LATextField* is similar to UITextField
* *LATokenField* is similar to NSTokenField in AppKit but adapted to iOS/Touch Interaction
* *LAScrollField* adds multiple lines and scrolling to *LATextField*

Requirements
-------------

* The iOS 5.0 SDK is needed to build. It can however run on iOS 4.3 or higher (iPhone/iPad universal app compatible).

* Devices: iPhone/iPad (*)
* Minimum iOS: 4.3
* Required Frameworks:
   * CoreText.framework
   * UIKit.framework

How to use FieldKit in your project
-----------------------------------

__Import Framework:__

* -ObjC in "Other Linker Flags" (in order to load categories - TEMP)
* Add FieldKit.framework
* Add FieldKit.bundle

__Copy Files:__

* All FieldKit
* FieldKit.bundle

Overview
--------

FieldKit doesn't subclass the text fields provided by UIKit. The text input, selection and manipulation is implemented from scratch. They conform to UITextInput...

__LATextField:__

* Prefix label (optional)
* Placeholder (optional)
* Single line

__LATokenField:__

* Token view cells (UIControl)
* Object <-> token representation
* Possible applications: Could be used to pick values from predefined list (ie. address book, tags, keywords, email adresses, ...)

__LAScrollField:__

* Multiple lines
* Ability to expand frame beyond initial frame
* Delegate is notified about changes and can control growing behaviour
* Will enable scrolling if content doesn't fit frame

Roadmap
-------

__Not Implemented:__

* iPad support (not tested)
* Selection Magnifier and Loupe views
* Selection change
* Spelling

Known Bugs
----------

Examples
--------

__FieldKit Overview:__

A FieldKit overview example with all fields presented in a UIScrollView.

__Message Composer:__

__Mail Composer:__

__Keywords:__

References
----------

__Implementation:__

* Apple SimpleCoreTextView (link to sample)
* Link to UITextInput references ...

__Other Projects:__

* EGOTextView (link to github repository)
* UIKit artwork extractor (linke to github repository)