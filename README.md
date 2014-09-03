FileInput
=========

Pump lines of text into Swift scripts.


### Usage

The interface is [borrowed from python](https://docs.python.org/2/library/fileinput.html).

	#!/usr/bin/xcrun swift -F <path-to-FileInput.framework>
    import FileInput
    for line in input() {
    	process( line )
    }

More documentation [here](../../wiki).


### Dependencies

Requires Xcode 6 beta 5 or later.

Until Xcode 6 is out of beta, the following is a convenient short cut
to have in your `.bashrc`.  Typing `sw` points your terminal to the
beta without having to switch the rest of your Mac off of Xcode 5.

    function sw()
    {
       export DEVELOPER_DIR=/Applications/Xcode6-Beta5.app/Contents/Developer
    }


### Installation

    % git clone git@github.com:otto-schnurr/FileInput-swift.git
    ...
    % cd FileInput-swift
    % sw # see above
    % xcodebuild
    ...

Move `./build/Release/FileInput.framework` to a convenient path
for your Swift scripts to reference.

*important:* If you plan to ship this framework in a binary, [Apple
recommends recompiling Swift frameworks with the same version of Xcode
as your binary](https://developer.apple.com/swift/blog/?id=2).


### Motivation

My hope is for this framework to eventually become redundant and
obsolete. The makers of Swift could come up with an elegant way to
pump lines of text into scripts. `println()` with string interpolation
shows how they handled this issue for standard output.

As of Xcode 6 beta 5, no text input facility exists outside of C or
Objective-C API. Until that changes, this framework is offered as an
alternative.


### License

MIT License, see http://opensource.org/licenses/MIT
