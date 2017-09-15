# CCLocalLibrary

### SomeCategorys that can be installed as a static library . (as framework , depends how you manage your pods) .

[![Version](https://img.shields.io/cocoapods/v/CCExtensionKit?style=flat)](http://cocoapods.org/pods/CCExtensionKit)

[![License](https://img.shields.io/cocoapods/l/CCExtensionKit?style=flat)](http://cocoapods.org/pods/CCExtensionKit)

[![Platform](https://img.shields.io/cocoapods/p/CCExtensionKit?style=flat)](http://cocoapods.org/pods/CCExtensionKit)

### What's new ?
---
**2017-09-15 17:56:19**

> rename 'CCLocalLib' to 'CCExtensionKit' .
> updated to '3.0.0'
> 
---
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

### How to use ?
---

For freshmen :

1. Download first or clone the git repo .
2. open `Terminal` , `cd` and make right into where the `Podfile` placed in .
3. `pod install`
4. open `*.xcworkspace`
5. see the content in the `Podfile` .
6. see the conten in the locallib.spec
7. if you can't find the spec file , use `mdfind` command in `Terminal`.	


  <del>`pod 'LocalLib'`</del> `pod 'CCExtensionKit'`
