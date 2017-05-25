# CCLocalLibrary

####SomeCategorys that can be installed as a local static library . (as framework , depends how you manage your pods) .

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


  `pod 'LocalLib' , :path => '../LocalLib'`
