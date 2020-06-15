//
//  MQExtensionKit.h
//  MQExtensionKit
//
//  Created by Elwinfrederick on 06/09/2017.
//  Copyright © 2017 冯明庆. All rights reserved.
//

#ifndef MQExtensionKit_h
#define MQExtensionKit_h

    #if __has_include(<MQExtensionKit/MQExtensionKit.h>)

        #import <MQExtensionKit/MQProtocolExtension.h>
        #import <MQExtensionKit/MQDataExtension.h>
        #import <MQExtensionKit/MQViewExtension.h>
        #import <MQExtensionKit/MQCommonExtension.h>

        #ifdef MQCustomExtension_h
            #import <MQExtensionKit/MQCustomExtension.h>
        #endif

        #ifdef MQRouterExtension_h
            #import <MQExtensionKit/MQRouterExtension.h>
        #endif

    #else

        #import "MQProtocolExtension.h"
        #import "MQDataExtension.h"
        #import "MQViewExtension.h"
        #import "MQCommonExtension.h"
        #import "MQRuntimeExtension.h"

        #ifdef MQCustomExtension_h
            #import "MQCustomExtension.h"
        #endif

        #ifdef MQRouterExtension_h
            #import "MQRouterExtension.h"
        #endif

    #endif

#endif /* MQExtensionKit_h */
