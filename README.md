Das Quadrat
===========

Das Quadrat is Foursquare API wrapper written in Swift.


####Features

+ Supports iOS and OSX.
+ Covers all API endpoints.
+ Authorization process implemented for both platforms.
+ Native authorization on iOS.
+ Image downloader/uploader.
+ Image cache.



####Installation

> Use `Quadrat.framework` for OSX project, `QuadratTouch.framework` for iOS projects. 

1. Add Das Quadrat as a submodule.

	`git submodule add git@github.com:Constantine-Fry/das-quadrat.git`
	
2. Drag-and-drop `Quadrat.xcodeproj` into your project.
3. Add `Quadrat` or `QuadratTouch` target in `Build Phases` -> `Target Dependencies`.
4. Add `new copy files Phase` by clicking on the `+` button at the top left of the panel.
⋅⋅1. Rename the new phase to "Copy Frameworks".
⋅⋅2. Set the "Destination" to "Frameworks".
5. Add `Quadrat.framework` or `QuadratTouch.framework` to this phase.


Bonn, December 2014.
