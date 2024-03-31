# NoticeMe
NoticeMe is an in-app SwiftUI notification/alert management library. NoticeMe offers an easy way to queue up notices to users, and has beautful built-in notices for you to use; while still offering fully customizable notice views.

## Quickstart Guide

### Adding the NoticeHandler

`NoticeHandler` is a `View` that handles displaying notices to the UI. Typically you place a `NoticeHandler` at the root of your application so that you dont overwhelm your UI with multiple notices at one time, while also allowing each notice to outlive any view that may create it.

In your App file, or anywhere above the view hierarchy that will create notices, import `NoticeMe`.

```swift
import NoticeMe
```

Then simply wrap the top of your view hierarchy with the `NoticeHandler`. For this example I am going to put the `NoticeHandler` in my App file.

```swift
@main
struct <YourAppNameHere>: App {
    var body: some Scene {
        WindowGroup {
            NoticeHandler {
                // Your Root View Here
            }
        }
    }
}
```

Now your application is setup to display notices!

### Queueing

NoticeMe uses a notice queuing system to prevent bombarding the UI with multiple notifications at a time. So when you want to show a notice, you add it to the queue and it will be displayed after all the prior notices have been displayed. If you need to make sure that a notice is displayed next you can specify that when you add the notice.

#### Get Access to the `NoticeManager`

NoticeMe uses a `NoticeManager` to manage the order, and speed at which your notices are pushed to the UI. So in order to start displaying notices in the UI, we first need to access the `NoticeManager`. You can easily do that from inside and `View` using the `@NoticeMe` property wrapper.

```swift
struct MyView: View {
    
    // You can name this variable whatever, we are going to name it noticeManager for these examples.
    @NoticeMe var noticeManager

    var body: some View {
        // View Body...
    }
}
```

Now that we have access to our `NoticeManager` we can use it to queue up notices. We use the `queueNotice` function from our `NoticeManager` to add a notice to the queue. `queueNotice` is a thread safe function so you can add notifications from anywhere.

```swift
    var body: some View {
        Button("Send Notice!") {
            noticeManager.queueNotice(/* Notice */)
        }

        // Async Code Works Too!

        Text("Hello, World!")
            .task {
                try await lengthyNetworkRequest()
                await noticeManager.queueNotice(/* Notice */)
            }
    }
```

### Built-In Notices

There are 4 different built-in Notices in NoticeMe, they each serve their own purpose, and have their own styling.

![Notices](https://github.com/Lukas-Simonson/NoticeMe/blob/main/Static/notices.gif)

#### Toast

```swift
    noticeManager.queueNotice(
        .toast(
            "Signed In",                            // Required
            message: "Welcome, Beloved User",       // Optional
            seconds: 2.0,                           // Required - Defaults to 2.0
            systemIcon: "person.fill.checkmark",    // Optional
            textColor: .black,                      // Required - Defaults to .black
            systemIconColor: .green,                // Required - Defaults to .black
            backgroundColor: .white                 // Required - Defaults to .white
        )
    )
```

#### Message

```swift
    noticeManager.queueNotice(
        .message(
            "Message From Ryan",                    // Required
            message: "Yo, I found this reall...",   // Optional
            seconds: 2.0,                           // Required - Defaults to 2.0
            systemIcon: "message.fill",             // Optional
            textColor: .black,                      // Required - Defaults to .black
            systemIconColor: .yellow,               // Required - Defaults to .black
            backgroundColor: .white                 // Required - Defaults to .white
        )
    )
```

#### Patch
```swift
    noticeManager.queueNotice(
        .patch(
            "Stop, you cant do that",   // Required
            seconds: 2.0,               // Required - Defaults to 2.0
            systemIcon: "xmark",        // Required
            iconColor: .red             // Required
        )
    )
```

#### Snackbar

```swift
    noticeManager.queueNotice(
        .snackbar(
            "This is a Snackbar",       // Required
            seconds: 2.0,               // Required - Defaults to 2.0
            textColor: .white,          // Required - Defaults to .white
            backgroundColor: .gray      // Required - Defaults to a custom gray color.
        )
    )
```

### Custom Notices

Notice me supports custom notices that can be any SwiftUI view. In order to create a new notice type you simply need to create a struct that conforms to the `Noticeable` protocol. The `Noticeable` protocol conforms to `View`, and henceforth requires a body where your custom notice view will be created. `Noticeable` also requires a `noticeInfo` property that controls how it's displayed. This `noticeInfo` property stores a `NoticeInfo` struct that represents the specifics of how your notice will work. You will need to provide it with the following information:

 - `alignment: Alignment` This is used to control the position of the notice when it is on screen.
 - Either `time: NoticeInfo.Time` or `duration: Duration` dependent on OS Version: This is how long the notice will appear on screen. All built-in notices default to 2 seconds.
 - `transition: AnyTransition` This is the transition will be used when the notice appears on screen.

A quick example of what a Custom Notice may look like would be the following:

```swift
struct NumberBubble: Noticeable {
    
    var noticeInfo: NoticeInfo = NoticeInfo(
        alignment: .top,        // Aligns to top center of screen
        duration: .seconds(3),  // Lasts for 3 seconds
        transition: .opacity    // Fades in and out
    )
    
    var number: Int
    
    init(for number: Int) {
        self.number = number
    }
    
    var body: some View {
        Text("\(number)")
            .bold()
            .padding()
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue))
    }
}
```

Then to add your new custom notice to the queue. You simply create an instance of your notice and pass it to the queueNotice function.

```swift
    noticeManager.queueNotice(NumberBubble(for: 42))
```

And Voila! You have your own custom notice!

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

To add [SwiftUI-Navigation-Router](https://github.com/Lukas-Simonson/NoticeMe) to your project do the following.
- Open Xcode
- Click on `File -> Add Packages`
- Use this repositories URL (https://github.com/Lukas-Simonson/NoticeMe.git) in the top right of the window to download the package.
- When prompted for a Version or a Branch, we suggest you use the branch: main
