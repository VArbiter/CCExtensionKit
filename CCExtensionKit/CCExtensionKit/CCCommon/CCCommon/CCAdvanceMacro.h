//
//  CCAdvanceMacro.h
//  CCChainKit
//
//  Created by 冯明庆 on 11/09/2017.
//  Copyright © 2017 ElwinFrederick. All rights reserved.
//

#ifndef CCAdvanceMacro_h
#define CCAdvanceMacro_h

/// if implement this macro .
/// the actions in this block can be executed when an litetime is dying .
/// note : this actions obey the stack in-out order .
/// note : which is first in , last out.
static void CC_ON_EXIT_BLOCK(__strong void(^*block)(void)) {
    (*block)();
}
#ifndef CC_ON_EXIT
    #define CC_ON_EXIT \
    __strong void(^CC_ON_EXIT_BLOCK)(void) __attribute__((cleanup(CC_ON_EXIT_BLOCK), unused)) = ^
#endif

/// add this to your method tail ,
/// it will warn you when some return value that want-to be used .
#ifndef CC_WARN_UNUSED_RESULT
    #define CC_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#endif

/// make c functions can be overloaded like the same function in java.
#ifndef CC_OVERLOADABLE_FUNCTION
    #define CC_OVERLOADABLE_FUNCTION __attribute__((overloadable))
#endif

/// make class a final class , forbidden all inhert actions .
/// note : add it just before @interface
/// eg :
///     CC_FINAL_CLASS @interface CCSomeClass : Class
///     @end
#ifndef CC_FINAL_CLASS
    #define CC_FINAL_CLASS __attribute__((objc_subclassing_restricted))
#endif

/// used for c-type functions , only worked when params && return value type both are basic types .
/// use it between return value type and function names :
/// eg : int CC_CONST_FUNCTION add(int , int)
/// note : compliar will only and always return the first time calculate value .
/// note : return value only depended on input params .
/// note : this macro only fit with const functions and no side-effect functions .
/// note : and also , not-allowed of all params and return values .
#ifndef CC_CONST_FUNCTION
    #define CC_CONST_FUNCTION __attribute__((const))
#endif

/// used to decorate the c-functions (c-functions only)
/// excute before main was intialized .
/// note : if specific '_priority_' , the functions will execute in the level you gave (and counted destructor).
#ifndef CC_VERY_FIRST_BEGINNING
    #define CC_VERY_FIRST_BEGINNING __attribute__((constructor))
    #define CC_VERY_FIRST_BEGINNING_PRIORITY(_priority_) __attribute__((constructor(##_priority_)))
#endif

/// used to decorate the c-functions (c-functions only)
/// excute after main was finished .
/// note : if specific '_priority_' , the functions will execute in the level you gave (and counted constructor).
#ifndef CC_DEAD_LAST_END
    #define CC_DEAD_LAST_END __attribute__((destructor))
    #define CC_DEAD_LAST_END_PRIORITY(_priority_) __attribute__((destructor(##_priority_)))
#endif

/// for c-type functions that not required to have a return value .
#ifndef CC_NO_RETURN
    #define CC_NO_RETURN __attribute__((noreturn))
#endif

/// force compliar use its' maximum strength
/// to align with a specific size when vars (in struct) get an mem-address.
#ifndef CC_STRUCT_ALIGNED
    #define CC_STRUCT_ALIGNED __attribute__((aligned))
    #define CC_STRUCT_ALIGNED_SIZE(_value_) __attribute__((aligned(##_value_)))
#endif

/// when used for stuct or union , it will make a memory constraint on each variable .
/// when used it for enum type , if indicates that should be used for the minimum size of a complete type .
/// note : CC_STRUCT_ALIGNED takes more spaces , CC_STRUCT_PACKED take lesser space cpmpare to CC_STRUCT_ALIGNED .
#ifndef CC_STRUCT_PACKED
    #define CC_STRUCT_PACKED __attribute__((__packed__))
#endif

/// make sure that a class can't be subclassed
/// eg :
/// CC_FINAL
/// @interface : FinalClass
/// @end
#ifndef CC_FINAL
    #if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
        # define CC_FINAL __attribute__((objc_subclassing_restricted))
    #else
        # define CC_FINAL
    #endif
#endif

#endif /* CCAdvanceMacro_h */
