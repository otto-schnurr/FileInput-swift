FileInput
=========

A pipe for streaming text from the command line into Swift scripts.


### Update: Use `readLine()`

> My hope is for this framework to eventually become redundant and
> obsolete. The makers of Swift could come up with an elegant way to
> pump lines of text into scripts.

In September 2015, the engineers at Apple granted my wish with the addition
of `readLine()` to Swift 2 (details [here][readline]). Their implementation
is robust, simple to use and highly recommended. I plan to use it for my own
scripts.

This repository will be maintained but mostly as an academic exercise.

If you're looking for an arcane excuse to use `FileInput`, obtaining the
[file path of each line of text][file path] is a minor detail that can be
interesting in certain cases.

    myScript.swift a.txt b.txt c.txt

However, processing multiple files is easily accomplished with `readLine()`.

    cat a.txt b.txt c.txt | myScript.swift

[file path]: https://github.com/otto-schnurr/FileInput-swift/wiki#querying-an-input-sequence
[readline]: https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Functions/index.html#//apple_ref/swift/func/s:FSs8readLineFT12stripNewlineSb_GSqSS_


### Usage

The interface is [borrowed from python](https://docs.python.org/2/library/fileinput.html).

	#!/usr/bin/swift -F <path-to-FileInput.framework>
    import FileInput
    for line in input() {
    	process(line)
    }

More documentation [here](../../wiki).


### Dependencies

Requires Xcode 7.0 or later.


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


### License

MIT License, see http://opensource.org/licenses/MIT
