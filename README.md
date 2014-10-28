FileInput
=========

Pipe lines of text into Swift scripts.


### Usage

The interface is [borrowed from python](https://docs.python.org/2/library/fileinput.html).

	#!/usr/bin/xcrun swift -F <path-to-FileInput.framework>
    import FileInput
    for line in input() {
    	process(line)
    }

More documentation [here](../../wiki).


### Dependencies

Requires Xcode 6.1 or later.


### Installation

    % git clone git@github.com:otto-schnurr/FileInput-swift.git
    ...
    % cd FileInput-swift
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

As of Xcode 6.1, no text input facility exists outside of C or
Objective-C API. Until that changes, this framework is offered as an
alternative.


### License

MIT License, see http://opensource.org/licenses/MIT
