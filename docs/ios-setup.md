# Native iOS Setup

## Recommended Stack

- SwiftUI for interface.
- SwiftData for local progress and question history.
- StoreKit later if paid access is needed.
- CloudKit later if sync is needed.
- XCTest for unit tests.
- Xcode previews for screen iteration.

## First Implementation Milestone

Build a clickable prototype with:

- Today screen
- One sample math session
- Answer feedback
- Progress summary
- Local progress model

No account system, backend, or payment layer should be added until the learning loop feels right.

## Local Build

Open the project with:

```sh
open PrepQuest.xcodeproj
```

Command-line build check:

```sh
xcodebuild -project PrepQuest.xcodeproj -scheme PrepQuest -configuration Debug -destination generic/platform=iOS -derivedDataPath /private/tmp/prepquest-derived CODE_SIGNING_ALLOWED=NO build
```
