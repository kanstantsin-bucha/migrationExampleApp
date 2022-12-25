
![main branch unit tests](https://github.com/kanstantsin-bucha/dg-client-ios/actions/workflows/ios-build-and-test-main.yml/badge.svg?branch=main)

# We are using fastlane match here


To get development profiles run
```
fastlane match development --readonly
```

To send to TestFlight, put ./AuthKey_4ZSC9LK9FP.p8 near that README,

then run
```
fastlane testflight
```
