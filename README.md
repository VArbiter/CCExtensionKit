# CCExtensionKit

##### Some custom categories for iOS with Objective-C. 

### 中文说明请点击[[这里](https://github.com/VArbiter/CCLocalLibrary/blob/master/README_CN.md)]

### Current Version 3.0.3

> pod 'CCExtensionKit' , '~> 3.0.3' // default is CCCore
> 
> > pod 'CCExtensionKit/CCFull' , '~> 3.0.3' . if you wanna install the whole Kit .

### Warning 
> CCLocalLib has no longer effect after version `2.2.3`
> 
> cause after `3.0.0` , CCLocalLib was renamed to `'CCExtensionKit'` .

### Note
> when install , default is `CCCore` , `CCCore` contains 
> 
> > `CCCommon` (Macros) , `CCProtocol` (Protocol) , `CCData` (NS Family), `CCView` (UI Family), `CCRuntime` (objc/ runtime associate)
> 
> when you wanna get to Full , install with `"CCExtensionKit/CCFull"` (note: `CCFull` had dependend on other vendors.)
> 
> **Instructions**
> 
> > CCCore : Core extensions . a abstract collection .
> 
> > CCFull : Full extensions . a abstract collection .
> 
> > CCExtensionAssets : Assets collection , preserve for future needs . (not available for now).
> 
> > CCCommon : Macros && Common tools .
> 
> > CCProtocol : CCProtocol . for CC . make all the sub-class of NSObject conforms to it .
> 
> > CCRuntime : Packaged for some runtime functions .
> 
> > CCDataBase : For now , only for [`Realm`](https://github.com/realm/realm-cocoa) ('~> 2.10.0').
> 
> > CCRouter : a extension Package Router for [`MGJRouter`](https://github.com/meili/MGJRouter) ('~> 0.9.3') && perform actions .
> 
> > CCData :  a extension actions for NS family .
> 
> > CCView :  a extension actions for UI family .
> 
> > CCCustom :  Custom classes or functions , dependend or based on other vendors .

### What's new ?
---
**2017-09-15 17:56:19**

> rename 'CCLocalLib' to 'CCExtensionKit' .
> updated to '3.0.0'
> 

**2017-08-10 14:50:52**
  
> After writing `CCChainOperate` for almost a month , I figured , that , **THIS CAN BE A KIT !**
> 
> Therefore , `CCChainKit` was created . 👏👏👏 .
> 
> 👉👉👉**[CCChainKit](https://github.com/VArbiter/CCChainKit)**
> 
> and Why I still using prefix __*CC*__ ?
> 
> cause I just still miss her .

**2017-08-06 15:38:09**

> Well ... I found that local libraries have some issues on spec dependency . Therefore , CCLocalLib was no longer a local lib. 
👏👏👏 -> now , jusy run `pod 'LocalLib' ` and cocoapods will do the rest .
>
> and probably , i won't use prefix `CC` any longer. 
> 
> maybe , `EL` will be the existance in the next project . EL , Elwin Frederick , of course .
>
>  single dog , single dog , single all the way. 🐶🐶🐶

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
pod "CCExtensionKit"
```

### Author

**ElwinFrederick, [elwinfrederick@163.com](elwinfrederick@163.com)**

### License

CCExtensionKit is available under the MIT license. See the LICENSE file for more info.
