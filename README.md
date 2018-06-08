# SFaceCompare

[![CI Status](https://img.shields.io/travis/BohdanNikoletti/SFaceCompare.svg?style=flat)](https://travis-ci.org/BohdanNikoletti/SFaceCompare)
[![Version](https://img.shields.io/cocoapods/v/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)
[![License](https://img.shields.io/cocoapods/l/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)
[![Platform](https://img.shields.io/cocoapods/p/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)

SFaceCompare is an simple libray for iOS to find and compare faces.
SFaceCompare works on top of dlib and OpenCV libraries. With usage of trained model.

## Features

- [x] Face detecting / extracting
- [x] Face aligment
- [x] Face matching
- [ ] Embed Faces.mlmodel into pod
- [ ] Support iOS 11.0
- [ ] Complete Documentation
- [ ] Test coverage

## Used Libraries

- [dlib](https://github.com/davisking/dlib) - Image processing
- [openCV](https://github.com/opencv/opencv) - Detecting face landmarks and face alignment

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- iOS 11.3+
- Xcode 8.3+
- Swift 4.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 1.1+ is required to build SFaceCompare.

To install library, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.3'
use_frameworks!

target '<Your Target Name>' do
    pod 'SFaceCompare'
end
```

Then, run the following command:

```bash
$ pod install
```
## Usage Example 

##### AppDelegate.swift

 **IMPORTENT! Drag a Faces.mlmodel from Example app in your project.**

In Your App delegate call SFaceCompare.opncvwrp.loadData() to load model related data. This Operation is long and async. So better put this before using methods from pod.
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    SFaceCompare.opncvwrp.loadData()
    return true
}
```
A ssimple as posible 
```swift
// 1: Create compare object
SFaceCompare(on: image1, and: image2)
// 2: Call compareFaces method with succes and error handlers
faceComparator.compareFaces(succes: { results in }, failure: {  error in })
```
## Credits

SFaceCompare is owned and maintained by [Bohdan Mihiliev](https://github.com/BohdanNikoletti) & [Anton Khrolenko](https://github.com/Thromkir)

## License

SFaceCompare is available under the MIT license. See the [LICENSE](https://github.com/BohdanNikoletti/SFaceCompare/blob/master/LICENSE) file for more info.
