# Repository Guidelines

## Project Structure & Module Organization
PrincipleMaker is managed with Tuist. The `PrincipleMaker/Project.swift` target pulls its sources from `PrincipleMaker/Sources`, where `Application` hosts app entry points and `Features` groups screen-specific modules. Shared assets, storyboards, and localized content live in `PrincipleMaker/Resources`. Tooling and dependency manifests sit under `Tuist/` and `Plugins/EnvironmentPlugin`, which define bundle identifiers, deployment targets, and Info.plist helpers. Generated artifacts should remain inside the `Derived/` folders and must not be committed.

## Build, Test, and Development Commands
Run `mise install` once to provision Tuist 4.78.2. Use `tuist generate` to create the editable Xcode workspace (`PrincipleMakerWorkspace.xcworkspace`), then `open PrincipleMakerWorkspace.xcworkspace` to launch Xcode. For scripted builds run `tuist build PrincipleMaker` and target specific simulators with `--device "iPhone 16 Pro"`. Execute `tuist test PrincipleMaker` to launch the XCTest suite when tests exist. Prefer `tuist clean` over manual folder deletions whenever you need to reset derived data.

## Coding Style & Naming Conventions
The project compiles with Swift 6.2; match that toolchain to avoid ABI mismatches. Keep indentation at four spaces and lines under roughly 120 characters. Follow Swift API Design Guidelines: types and protocols in UpperCamelCase, methods and properties in lowerCamelCase, and enums with lowerCamelCase cases. Group feature-specific files inside `Sources/Features/<FeatureName>`; suffix view implementations with `View` and view models with `ViewModel`. Use Xcode’s “Editor > Structure > Re-Indent” before committing to normalize formatting.

## Testing Guidelines
We rely on XCTest. Mirror production modules under `PrincipleMaker/Tests/<FeatureName>Tests`, naming suites `<FeatureName>Tests` and methods `test_<behavior>_when_<scenario>`. Store mocks and fixtures in a `__Mocks__` subfolder adjacent to the test file. Target meaningful coverage for new logic and add at least one snapshot test when you change UI rendering. Run `tuist test PrincipleMaker --device "iPhone 16 Pro"` locally before requesting review.

## Commit & Pull Request Guidelines
Follow the existing history: prefix the subject with the change type (`Feat,`, `Fix,`, `Chore,`) followed by a concise, imperative description (English or Korean is acceptable). Squash incidental WIP commits prior to pushing. Pull requests should summarise the change, list manual or automated test steps, link related issues, and attach screenshots or recordings for UI updates. Request review from an iOS maintainer and wait for CI to pass before merging.
