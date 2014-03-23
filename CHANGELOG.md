## 0.1.3

Other:
  
  - Support for CocoaPods added

## 0.1.2

Features:

  - Selection menu with support for the clipboard operations: Copy, Cut, Paste, Select and Select All
  - Autocorrection while user is typing with suggestions (using UITextInputStringTokenizer)
  - Spell-check support with misspelled words overlay view
  
Bugfixes:

 - Fix bug in CTFrameGetLineOrigins. Calling it with CFRange of length 0 causes it to crash.
 
Examples:

 - Refactored all examples, including project structure, resources and name
 - Added MailComposer and MessageComposer example placeholders
 
## 0.1.1

Features:
 
  - Text selection change with drag gesture
  - Text loupe magnifier for caret selection
  - Text range magnifier for range selection
  - FKTextRangeView UI with selection grabbers (FKSelectionGrabber)
  
Bugfixes:

  - fix double-tap user interaction when text field is not in editing mode  

Documentation:
  
  - Architecture diagram
  - UX diagram
   
## 0.1.0

Features:

  - FKTextField view that displays text and the user can select or edit 
  - FKTokenField (subclass of FKTextField) that provides tokenized text editing similar to the address field in the iOS Mail application 
  - Text editing with single tap and caret view support
  - Text selection with double tap and range view support
  - Token selection with single tap
  - Token draggable after long press + drag
  - Support for iOS 4.1 or later, iOS 5 and iOS 6

Documentation:

  - Full feature list
  - Basic installation and usage guide

Examples:

  - Single-view application with FKTextField and FKTokenField
  - Multi-colored token fields example
