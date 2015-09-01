Das Quadrat [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
===========

Das Quadrat is Foursquare API wrapper written in Swift.


###Features

+ Supports iOS and OSX.
+ Covers all API endpoints.
+ Authorization process implemented for both platforms.
+ Native authorization on iOS.
+ Image downloader/uploader.
+ Image cache.
+ Supports multiple accounts.


###Installation

#### Carthage Installation

Install Das Quadrat using the [Carthage](http://github.com/Carthage/Carthage) dependency manager.

```
github "Constantine-Fry/das-quadrat" >= 1.0
```

#### Cocoapods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'QuadratTouch', '>= 1.0'
```

#### Embedded framework (iOS 8.0+)

1. Add Das Quadrat as a submodule.
	`git submodule add git@github.com:Constantine-Fry/das-quadrat.git`
2. Drag-and-drop `Quadrat.xcodeproj` into your project. The project has two targets: Quadrat.framework for OSX project, QuadratTouch.framework for iOS projects.
3. Add new target in "Build Phases" -> "Target Dependencies".
4. Click the `+` button at the top left of the panel and choose "New copy files phase".
  * Rename the new phase to "Copy Frameworks".
  * Set the "Destination" to "Frameworks".
5. Add Quadrat framework to this phase.
6. Here is the [image](https://cloud.githubusercontent.com/assets/239692/5367193/367f8640-7ffa-11e4-8b9b-88cef33bcd79.png) to visualise the result.
7. Read [wiki](https://github.com/Constantine-Fry/das-quadrat/wiki) for details.

You can add source code files directly into your project to support iOS 7.0.

###Usage

#####Setup session

```swift
let client = Client(clientID:       "FOO.................FOO",
   					clientSecret:   "BAR.................BAR",
    				redirectURL:    "testapp123://foursquare")
var configuration = Configuration(client:client)
Session.setupSharedSessionWithConfiguration(configuration)

let session = Session.sharedSession()
```

#####Search request

```swift
var parameters = [Parameter.query:"Burgers"]
parameters += self.location.parameters()
let searchTask = session.venues.search(parameters) {
    (result) -> Void in
    if let response = result.response {
		self.venues = response["venues"] as [JSONParameters]?
		self.tableView.reloadData()
    }
}
searchTask.start()
```

#####Multi request

```swift
let task1 = self.quadratSession.users.get()
let task2 = self.quadratSession.users.friends(userId: "self", parameters: nil)

let multiTask = self.quadratSession.multi.get([task1, task2]){
	(responses) -> Void in
	println(responses)
}
multiTask.start()
```

#####Native authorization

The library will attempt to authorize natively via the actual Foursquare app, if installed. It will switch to the app to authorize, and then switch back to your app on success. Currently, there is no mechanism in place in Foursquare's app to switch back to your app if the user cancels the authorization from there, so the user will need to return to your app manually if they choose to cancel the authorization.

If the Foursquare app is not installed on the user's device, your app will instead present a modal view controller containing a `UIWebView` that will display a web-based authorization screen instead. This occurs without leaving your app, and can be cancelled to return to the previous screen.

On iOS9 an app must declare which URL scheme it wants to check with `canOpenURL:`. 
To enable native authorization with Foursquare app you must add `foursquareauth` to `LSApplicationQueriesSchemes` array
in info.plist file in your project.


###Requirements

Swift 2.0 / iOS 8.0+ / Mac OS X 10.9+

###License

The BSD 2-Clause License. See License.txt for details.

===========
Bonn, December 2014.
