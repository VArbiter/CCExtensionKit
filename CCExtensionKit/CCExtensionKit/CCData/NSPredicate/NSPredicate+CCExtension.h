//
//  NSPredicate+CCExtension.h
//  CCLocalLibrary
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (CCExtension)

+ (instancetype) common : (NSString *) sRegex ;

/// YYYY-MM-DD HH:mm:ss
+ (instancetype) time ;
+ (instancetype) macAddress ;
+ (instancetype) webURL ;

// only in china

+ (instancetype) cellPhone ;
+ (instancetype) chinaMobile ;
+ (instancetype) chinaUnicom ;
+ (instancetype) chinaTelecom ;

+ (instancetype) email ;
+ (instancetype) telephone ;

+ (instancetype) chineseIdentityNumber ;
/// eg: 湘K-DE829 , 粤Z-J499港
+ (instancetype) chineseCarNumber ;
+ (instancetype) chineseCharacter ;
+ (instancetype) chinesePostalCode ;
+ (instancetype) chineseTaxNumber ;

- (id) ccEvalute : (id) object ;

@end

@interface NSString (CCExtension_Regex)

/// YYYY-MM-DD HH:mm:ss
- (instancetype) isTime ;
- (instancetype) isMacAddress ;
- (instancetype) isWebURL ;

// only in china
+ (BOOL) ccAccurateVerifyID : (NSString *) sID;

- (instancetype) isAccurateIdentity ;
- (instancetype) isCellPhone ;
- (instancetype) isChinaMobile ;
- (instancetype) isChinaUnicom ;
- (instancetype) isChinaTelecom ;
- (instancetype) isTelephone ;
- (instancetype) isEmail ;
- (instancetype) isChineseIdentityNumber ;
- (instancetype) isChineseCarNumber ;
- (instancetype) isChineseCharacter ;
- (instancetype) isChinesePostalCode ;
- (instancetype) isChineseTaxNumber ;

@end
