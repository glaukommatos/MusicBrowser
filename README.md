#  MusicBrowser

![Screenshot](https://raw.githubusercontent.com/glaukommatos/MusicBrowser/main/screenshot.png "Screenshot")

## Building & Running

Build the `MusicBrowser` target in Xcode to run either on a simulator or a connected iOS device.

## Testing

You can either run the tests via Xcode's testing UI or on the command line via a command similar to

    xcodebuild test -scheme MusicBrowser -destination 'platform=iOS Simulator,name=iPhone 12 Pro'

## TODO

### Error Handling

I have not yet implemented any handling for dealing with a failed load or a failed search. Right now there'll just be no results.

### Testing

More tests would be nice still– in particular the ViewControllers can probably use a bit more love, but I'm still experimenting with how
I would like to best approach this.

### Dependency-Injection

The ViewControllers are creating their own dependencies, which for the scope of this application might be fine right now, but as the
application would get larger, it would be sensible to consider relieving the ViewControllers of this responsibility either via a DI framework
or by creating some convenience functions outside of the ViewControllers for taking care of this. Often the best option for testability
in my experience has been initializer injection, but for iOS applications I'm still experimenting and reading up on this particular issue.

In the past when I've done more work with Spring I really appreciated the ability to simply annotate a class and have Spring's DI
framework automatically construct instances based on the types in the constructor, but having done relatively few large iOS projects
I am still learning about how people tend to approach this and what is more likely to be considered idiomatic.
