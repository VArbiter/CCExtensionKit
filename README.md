# MQExtensionKit

##### Some custom categories for iOS with Objective-C. 

[![Version](https://img.shields.io/cocoapods/v/MQExtensionKit.svg?style=flat)](http://cocoapods.org/pods/MQExtensionKit)

[![License](https://img.shields.io/cocoapods/l/MQExtensionKit.svg?style=flat)](http://cocoapods.org/pods/MQExtensionKit)

[![Platform](https://img.shields.io/cocoapods/p/MQExtensionKit.svg?style=flat)](http://cocoapods.org/pods/MQExtensionKit)

### 中文说明请点击[[这里](https://github.com/VArbiter/MQExtensionKit/blob/master/README_CN.md)]

### Current Version 3.7.0

> pod 'MQExtensionKit' , '~> 3.7.0' // default is MQCore
> 
> > pod 'MQExtensionKit/MQFull' , '~> 3.7.0' . if you wanna install the whole Kit .

### Warning
>
> CCExtensionKit has no longer effect after version `3.7.0`
> 
> cause after `3.7.0` , CCLocalLib was renamed to `'MQExtensionKit'` .
>
> CCLocalLib has no longer effect after version `2.2.3`
> 
> cause after `3.0.0` , CCLocalLib was renamed to `'CCExtensionKit'` .
> 
> CCExtensionKit had import the `AdSupport.framework`.
> 
> therefore , be ware when submit your app to App Store .

### Note
> when install , default is `MQCore` , `MQCore` contains 
> 
> > `MQCommon` (Macros) , `MQProtocol` (Protocol) , `MQData` (NS Family), `MQView` (UI Family), `MQRuntime` (objc/ runtime associate)
> 
> when you wanna get to Full , install with `"MQExtensionKit/MQFull"`

**Instructions**
> 
> > MQCore : Core extensions . a abstract collection .
> 
> > MQFull : Full extensions (not included MQDataBase && MQCustom) . a abstract collection .
> 
> > MQExtensionAssets : Assets collection , preserve for future needs . (not available for now).
> 
> > MQCommon : Macros && Common tools .
> 
> > MQProtocol : MQProtocol . for MQ . make all the sub-class of NSObject conforms to it .
> 
> > MQRuntime : Packaged for some runtime functions .
> 
> > MQDataBase : Wrappers for [`Realm`](https://github.com/realm/realm-cocoa) ('~> 2.10.2') && [`FCModel`](https://github.com/marcoarment/FCModel)
> 
> > MQRouter : a extension Package Router for [`MGJRouter`](https://github.com/meili/MGJRouter) ('~> 0.9.3') && perform actions .
> 
> > MQData :  a extension actions for NS family .
> 
> > MQView :  a extension actions for UI family .
> 
> > MQOrigin : a kit that for develop for custom views / medias / datas .
> 
> > MQCustom :  Custom classes or functions , dependend or based on other vendors .

### What's new ?
---
---
**2018-07-30 12:52:51**

> using new prefix  `MQ` .

**2018-07-09 17:37:21**

> added `NSLock+CCExtension` (CCData) for lock issues .
>
> added `CCNull` (CCOrigin) for replace NSNull holding issues .

**2018-06-27 20:03:04**

> added `CCPointMarker` (CCOrigin) for collect infos on our own ,
> 
> added `CCCrashCatcher` (CCOrigin) for catch crashes , 
> 
> added `CCPhotoManager` (CCOrigin) for pick photos / videos in album ,
> 
> added `CCAudioRecorder` (CCOrigin) for recording audios .

**2018-06-25 19:22:00**

> added `CCTaskManager` (CCOrigin) for easy queue tasks .

**2018-05-04 21:55:33**

> added `CCAuthentication` (CCCommon) for touch id && face id verify , `CCIAPManager`(CCOrigin) for in app purchase  .

**2018-04-23 18:53:35**

> make prefix all `cc_` . remove CCDataBase && CCCustom from CCFull .

**2017-12-22 15:59:44**

> translate all comment in header file into chinese .

**2017-11-28 12:39:59**

> rebuilt `CCBridgeWrapper` in `CCRouter` .

**2017-11-01 19:24:27**

> fix annoying warnings under Xcode 9.

**2017-09-15 17:56:19**

> rename 'CCLocalLib' to 'CCExtensionKit' .
> updated to '3.0.0'
> 

**2017-08-10 14:50:52**
  
> After writing `CCChainOperate` for almost a month , I figured , that , **THIS CAN BE A KIT !**
> 
> Therefore , `CCChainKit` was created . 👏👏👏 .
> 
> ~~👉👉👉 **[CCChainKit](https://github.com/VArbiter/CCChainKit)**~~
> probably I won't update CCChainKit for a long time , I don't have that time or energy to continue contribute on two repos .

**2017-08-06 15:38:09**

> Well ... I found that local libraries have some issues on spec dependency . Therefore , CCLocalLib was no longer a local lib. 
👏👏👏 -> now , jusy run `pod 'LocalLib' ` and cocoapods will do the rest .

**2017-07-01 19:49:01**
> I wrote a new library called `CCChainOperate` .
 Why I wrote it ?
>
> well , after years of writing objective-c , i figured some dis-advantage of it . such as you have to use `[]`  everywhere . i just hate that . 
> 
> but , as we all know , on the opposite side , `swift` was much better , easily to use , simple to unsderstand (though its haven't stable yet). 
> 
>  Someday , i find , that block , can actually can perform a style like swift , therefore `CCChainOperate ` was born (not complete yet , maybe , forever , but I'll try.).
>  
>  Also , heavily inspired by react-Objc .

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Requirements

Already done in pod spec.

### Installation

CCExtensionKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MQExtensionKit"
```

### Author

**ElwinFrederick, [elwinfrederick@163.com](elwinfrederick@163.com)**

### License

CCExtensionKit is available under the MIT license. See the LICENSE file for more info.
