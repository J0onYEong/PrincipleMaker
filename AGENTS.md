# Ground rule

- use context7 mcp server for latest development doucuments if needed. 

# Repository Guidelines

## Project Specifications

- **iOS:** 26  
- **Swift:** 6.2  
- **UI Framework:** UIKit-based, with partial SwiftUI integration  
- **Project Management:** Tuist  
- **Testing Framework:** Swift Testing (for unit testing) 

## Project Structure & Module Organization

This project uses Tuist for project management.  
You can view the module dependency graph in the `Project.swift` file.  
The final application target and its module configuration are defined in `root/PrincipleMaker/Project.swift`.

Currently, the project consists of a single module, but as it grows, I plan to split it into multiple modules.  
Please keep in mind that even though all features are currently located in one directory, they should not have strong dependencies on each other.  
You are encouraged to suggest module separations when appropriate.


## Test Code guide

Each module has its own test target.  
If you want to test a specific feature, write the test code in the test target’s source directory located at `moduleRoot/Tests/`.

Currently, all features are contained within a single module, so there is only one unit test target.  
To keep the tests organized, you should create a separate directory for each feature’s tests.

For example, if you are testing `AFeature` and I ask you to implement a type for it,  
create a directory named `ATests` (if it doesn’t already exist) and add a file named `SomeTypeTests.swift` for the test code.

Each test case should follow the Given–When–Then structure.  
For readability and maintainability, use one assertion per test case.  
Also, use Korean naming for test case method names for better contextual readability.
use "sut" naming for system under test.

Example:
```swift
@Test
func 올바르게_데이터가_수집되는지_확인() {
    // Given
    let sut = SomeType()

    // When
    let result = sut.someMethod()

    // Then
    #expect(result, true, "값이 true가 아님")
}
```

## External Dependency add guide

If I provide you with a `.git` link and version for a dependency,  
you should add that dependency to the `Tuist/Package.swift` file.

If I ask you to create a dependency graph for that dependency,  
you should refer to `Project.swift` and establish the appropriate relationships.

After updating the dependency configuration,  
run `tuist install` to fetch the dependency from the provided link,  
and then run `tuist generate` to apply the updated dependency graph.

## Coding Style & Naming Conventions

### View & ViewController

I don’t use Storyboards for views or view controllers.  
However, I want to use an initializer with no arguments.  
You should create initializers as shown below:

```swift
init() {
    super.init(frame: .zero)
    // call initialization functions here
}
required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
```

I use two setup functions for views and view controllers:
```swift
func attribute() {
    // configure attributes
    // all addSubview calls must take place here
}

func layout() {
    // configure layouts
}
```
you muse call these functions in `init() { ... }`.

### UI Design guide

This project targets iOS 26 and I actively use Liquid Glass Design.  
You should follow this design style throughout the project.

Do not use any custom fonts or colors.  
Always use system colors and system fonts to maintain consistency with the iOS design language.

You should refer to the following website for Liquid Glass design guidance:  
https://sebvidal.com/blog/whats-new-in-uikit-26

Follow the design principles and styles described there when implementing UI.

## Commit & Pull Request Guidelines

Follow the existing history: prefix the subject with the change type (`Feat,`, `Fix,`, `Chore,`) followed by a concise, imperative description (English or Korean is acceptable). Squash incidental WIP commits prior to pushing. Pull requests should summarise the change, list manual or automated test steps, link related issues, and attach screenshots or recordings for UI updates. Request review from an iOS maintainer and wait for CI to pass before merging.

When i order "commit for changes", you should commot staged files only.
