//
//  CCExtensionKit.h
//  CCExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#ifndef CCExtensionKit_h
#define CCExtensionKit_h

    #if __has_include(<CCExtensionKit/CCExtensionKit.h>)

        #import <CCExtensionKit/CCProtocolExtension.h>
        #import <CCExtensionKit/CCDataExtension.h>
        #import <CCExtensionKit/CCViewExtension.h>
        #import <CCExtensionKit/CCCommonExtension.h>
        #import <CCExtensionKit/CCRuntimeExtension.h>

        #ifdef _CCCustomExtension_
            #import <CCExtensionKit/CCCustomExtension.h>
        #endif

        #ifdef _CCCRouterExtension_
            #import <CCExtensionKit/CCRouterExtension.h>
        #endif

        #ifdef _CCCDataBaseExtension_
            #import <CCExtensionKit/CCDataBaseExtension.h>
        #endif

    #else

        #import "CCProtocolExtension.h"
        #import "CCDataExtension.h"
        #import "CCViewExtension.h"
        #import "CCCommonExtension.h"
        #import "CCRuntimeExtension.h"

        #ifdef _CCCustomExtension_
            #import "CCCustomExtension.h"
        #endif

        #ifdef _CCCRouterExtension_
            #import "CCRouterExtension.h"
        #endif

        #ifdef _CCCDataBaseExtension_
            #import "CCDataBaseExtension.h"
        #endif

    #endif

#endif /* CCExtensionKit_h */
