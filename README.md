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

Install Das Quadrat using the [Carthage](http://github.com/Carthage/Carthage) dependency manager.

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


###Requirements

Swift 1.2 / iOS 8.0+ / Mac OS X 10.9+

###License

The BSD 2-Clause License. See License.txt for details.

===========
Bonn, December 2014.
