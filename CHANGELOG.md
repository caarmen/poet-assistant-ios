Change Log
==========

1.7.5  *(2021-01-03)*
--------------------
* Remove link to personal website from about screen

1.7.4 *(2020-12-22)*
--------------------
* Fix crash updating suggestions
* Update copyright for about screen

1.7.3 *(2020-12-21)*
--------------------
* Maintenance updates:
  - Set deployment target to 12
  - Swift version: 5.0 -> 5.3.2
  - Remove/replace deprecated code
  - Fix some tests which failed due to timeouts
  - Fix some tests which failed due to OS UI changes in iOS 14 (share dialog, springboard)

1.7.2 *(2019-09-25)*
--------------------
* Update for Xcode 11 compatibility:
  - Change the certificate type
  - Remove the custom theme setting and rely on the system theme setting

1.7.1 *(2019-03-30)*
--------------------
* Update to Swift 5

1.7.0 *(2018-12-29)*
--------------------
* Add a setting for reverse thesaurus lookup.
* Improve voice selection list:
  - Show a checkmark on the selected voice
  - Allow stopping playback

1.6.1 *(2018-12-23)*
--------------------
* Issue #21: Improve file handling. Show a saving/saved status in the composer.

1.6.0 *(2018-12-09)*
--------------------
* Add a list of the previous words of the day.

1.5.1 *(2018-11-30)*
--------------------
* Current the distribution warning: use the same bundle version in the main app and the today extension.

1.5.0 *(2018-11-26)*
--------------------
* Added "word of the day" widget.

1.4.0 *(2018-11-17)*
--------------------
* Added function to share search results

1.3.0 *(2018-11-11)*
--------------------
* Added settings for rhymer rules for different pronunciations.
* Improved the composer text hint (to mention the play icon).
* Make the status bar the same color as the navigation bar.

1.2.0 *(2018-11-04)*
--------------------
* Added a dark theme setting
* Added a "random word" search suggestion
* Added a "favorites" feature, to star your favorite words.

1.1.0  *(2018-10-28)*
--------------------
* Added a "More" item to the "Composer" navigation bar. This menu item contains:
  - Link to "Settings" (previously this was is the bottom tab bar)
  - Link to "About" (previously this was inside "Settings")
  - Link to "Share" (previously this was directly in the "Composer" tab).
  - File operations: New file, import file (external or internal), save as
* Fixed a crash when attempting to share the poem text on an ipad.

