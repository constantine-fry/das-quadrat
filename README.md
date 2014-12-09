Das Quadrat
===========

Das Quadrat is Foursquare API wrapper written in Swift.


###Features

+ Supports iOS and OSX.
+ Covers all API endpoints.
+ Authorization process implemented for both platforms.
+ Native authorization on iOS.
+ Image downloader/uploader.
+ Image cache.



###Installation

#####Embedded framework.

1. Add Das Quadrat as a submodule.
`git submodule add git@github.com:Constantine-Fry/das-quadrat.git`
	
2. Drag-and-drop `Quadrat.xcodeproj` into your project. The project has two targets: Quadrat.framework for OSX project, QuadratTouch.framework for iOS projects. 
3. Add new target in "Build Phases" -> "Target Dependencies".
4. Click the `+` button at the top left of the panel and choose "New copy files phase".
  * Rename the new phase to "Copy Frameworks".
  * Set the "Destination" to "Frameworks".
5. Add Quadrat framework to this phase.
6. Here is the [image](https://cloud.githubusercontent.com/assets/239692/5366551/0b451332-7ff5-11e4-8738-2a7c266176e6.png) to visualise the result.

#####Source code.
+ Yet to be written.


===========
Bonn, December 2014.
