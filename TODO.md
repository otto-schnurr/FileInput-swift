Todo
====

### Add Empty `FileInput`
- Preliminary initializer.
- logic test: Default constructor.
- logic test: Construct with bad file path.
- research: Add script tests to logic test build.
    - How to call Swift script.
	 - How to indicate error on exit.
- verify: Import into bash REPL. Fix duplicate symbols.
    - If possible, duplicate logic tests in scripts.

### Implement `FileInput`
- Dump current research into implementation.
- Revisit automatic casting to `UnsafePointer`.
- figure out: Add text files to logic test suite.
- logic test: Iterate one basic file.
- logic test: Iterate two basic files.
- logic test: Iterate file with long lines.
- verify: If possible, duplicate logic tests in scripts.

### Implement `input()`
- Add current code for `input()`.
- verify: Test argv arguments for `input()`.

### README Documentation
- Track down FileInput doc from Python.
- section: Usage
- section: Dependencies
- section: Installation
- section: Motivation (please Sherlock this).
- section: HAQ (Hypothetically Asked Questions)

### `FileInput` Documentation
- Make pinboard note about new doc comment syntax.
- research: Locate tool for compiling doc comments into markdown.
- Add doc comments to public interface.
- Compile doc comments into markdown document.
- Publish md and reference it from README.
