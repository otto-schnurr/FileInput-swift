FileInput
=========

Pump lines of text into Swift scripts.


### Usage

	#!/usr/bin/xcrun swift -F <path-to-FileInput.framework>
    import FileInput
    for line in input() {
    	// Newline characters are not removed.
    	print( line )
    }


### Dependencies
Requires Xcode 6 beta 5 or later.

Until Xcode 6 is out of beta, the following function is a convenient
short cut to have in your `.bashrc`.  Typing `sw` in your terminal shell
will point it to the beta without having to switch the rest of your Mac 
off of Xcode 5.

    function sw()
    {
       export DEVELOPER_DIR=/Applications/Xcode6-Beta5.app/Contents/Developer
    }


### License
MIT License, see http://opensource.org/licenses/MIT
