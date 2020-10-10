<img src="https://cdn.rawgit.com/BohdanNikoletti/SFaceCompare/7acc1b9f/GraphicMaterials/logo.png" width="64" height="64"> SFaceCompare: compare faces on your iOS device
======================================
[![CI Status](https://img.shields.io/travis/BohdanNikoletti/SFaceCompare.svg?style=flat)](https://travis-ci.org/BohdanNikoletti/SFaceCompare)
![iOS 12.0](https://img.shields.io/badge/iOS-11.3%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)
[![License](https://img.shields.io/cocoapods/l/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)
[![Platform](https://img.shields.io/cocoapods/p/SFaceCompare.svg?style=flat)](https://cocoapods.org/pods/SFaceCompare)

SFaceCompare is a simple library for iOS to find and compare faces.
SFaceCompare works on top of dlib and OpenCV libraries. With usage of trained model.

## Features

- [x] Face detecting / extracting
- [x] Face aligment
- [x] Face matching

## Used Libraries

- [dlib](https://github.com/davisking/dlib) - Image processing
- [openCV](https://github.com/opencv/opencv) - Detecting face landmarks and face alignment
- [SameFace](https://github.com/BohdanNikoletti/SameFace) - Core that connects dlib & openCV functionality under the hood

These libraries were used to create SameFace.framework which src on CVDlibUtils branch

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
### Import Faces.mlmodel
Make import of Faces.mlmodel file into your actual project. To make this.
1) Open Example App provided with this repo
2) Find Faces.mlmodel
3) Drag/Copy-Paste into root of your project
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 1.1+ is required to build SFaceCompare.

To install library, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
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
Faces are the same           |  Faces are different
:---------------------------:|:-------------------------:
<img src="https://rawgit.com/BohdanNikoletti/SFaceCompare/master/GraphicMaterials/usageSampleSucces.gif" /> | <img src="https://rawgit.com/BohdanNikoletti/SFaceCompare/master/GraphicMaterials/compareWithDiffFaces.gif" />

##### AppDelegate.swift
In Your App delegate call SFaceCompare.opncvwrp.loadData() to load model related data. This Operation is long and async. So better put this before using methods from pod.
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    SFaceCompare.prepareData()
    return true
}
```
As simple as possible
```swift
// 1: Create compare object
let faceComparator = SFaceCompare(on: image1, and: image2)
// 2: Call compareFaces method with success and error handlers
faceComparator.compareFaces{ results in ... }
```
## Credits

SFaceCompare is owned and maintained by [Bohdan Mihiliev](https://github.com/BohdanNikoletti) & [Anton Khrolenko](https://github.com/Thromkir)

## License

SFaceCompare is available under the MIT license. See the [LICENSE](https://github.com/BohdanNikoletti/SFaceCompare/blob/master/LICENSE) file for more info.
