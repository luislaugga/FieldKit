
LATextField + LATokenField
==========================


Introduction
------------

__LATextField:__

* Prefix label (optional)
* Placeholder (optional)
* Multiple lines

__LATokenField:__

* Token view cells (UIControl)
* Object <-> token representation
* Possible applications: Could be used to pick values from predefined list (ie. address book, tags, keywords, email adresses, ...)

Deployment
---------

* Devices: iPhone/iPad (*)
* Minimum iOS: 4.3
* Requires CoreText.framework

Usage
-----

Framework
=========

* -ObjC in "Other Linker Flags" (in order to load categories - TEMP)
* Add FieldKit.framework

Copying Source
==============

...

Overview
--------


Roadmap
-------


Known Bugs
----------

Examples
--------

* Message Composer (as used in messages)
* Mail Composer (as used in mail)
* Keywords (add/remove tokens)


References
----------

* EGOTextView
* Apple SimpleCoreTextView
* UIKit artwork extractor