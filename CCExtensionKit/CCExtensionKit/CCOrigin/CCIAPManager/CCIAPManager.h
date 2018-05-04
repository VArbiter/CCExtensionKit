//
//  CCIAPManager.h
//  CCLocalLibrary
//
//  Created by ElwinFrederick on 04/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import <Foundation/Foundation.h>

@import StoreKit;

typedef NS_ENUM(NSInteger , CCIAPStatus) {
    CCIAPStatus_Purchase_Fail = 0,
    CCIAPStatus_Purchase_Success ,
    CCIAPStatus_Restore_Fail ,
    CCIAPStatus_Restore_Success
};

@class CCIAPManager ;

@protocol CCIAPManagerDelegate <NSObject>

@required
- (void) cc_IAP_manager : (CCIAPManager *) manager
                 result : (id) result ;

/// when payment is done . // 支付完成调用
/// return YES to end payment transaction .// 返回 YES 来结束支付事物
- (BOOL) cc_IAP_manager : (CCIAPManager *)manager
           original_url : (NSURL *) url_original
           final_result : (NSMutableDictionary *) d_result ;

@optional
- (void) cc_IAP_manager : (CCIAPManager *) manager
                  error : (NSError *) error ;
- (void) cc_IAP_manager : (CCIAPManager *) manager
     request_did_finish : (SKRequest *) request ;

- (void) cc_IAP_manager : (CCIAPManager *) manager
          payment_queue : (SKPaymentQueue *) queue
                removed : (NSArray<SKPaymentTransaction *> *) transactions ;
- (void) cc_IAP_manager : (CCIAPManager *) manager
          payment_queue : (SKPaymentQueue *) queue
 restore_completed_fail : (NSError *) error;
- (void) cc_IAP_manager : (CCIAPManager *) manager
      restore_completed : (SKPaymentQueue *) queue ;

@end

typedef NSString * CCIAPParamsKey NS_EXTENSIBLE_STRING_ENUM ;
FOUNDATION_EXPORT CCIAPParamsKey CC_IAP_PARAMS_RECEIPT_KEY ; // @"receipt"
FOUNDATION_EXPORT CCIAPParamsKey CC_IAP_PARAMS_TRANSACTION_ID_KEY ; // @"transaction_id"

@interface CCIAPManager : NSObject

/// absolute singleton // 绝对单例
+ (instancetype) shared ;
@property (nonatomic , assign) id <CCIAPManagerDelegate> delegate ;

- (void) cc_purchase : (NSString *) s_product_id ; // use it with delegate // 这个和代理一起使用
- (void) cc_purchase : (NSString *) s_product_id
              result : (void(^)(CCIAPManager *manager , id result , NSError *error)) cc_result_block ;

// return YES to end payment transaction .// 返回 YES 来结束支付事物
@property (nonatomic , copy) BOOL (^cc_upload_receipt_block)(CCIAPManager *manager , NSURL * url_original , NSMutableDictionary *d_result) ;

@end

/* 
    apple respose status code : // 苹果反馈的状态码:
    21000 - App Store can't read you JSON data. // 商店无法读取你提供的JSON数据 .
    21002 - receipt doesn't compare a right format. // 收据数据不符合格式
    21003 - receipt can't be verified. // 收据无法被验证
    21004 - the shared keys you provided doesn't compare the account shared key. // 你提供的共享密钥和账户的共享密钥不一致
    21005 - server is not available. // 收据服务器当前不可用
    21006 - receipt is available , but data is out of date . when this message received , the decoded receipt also included in the response body. // 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
    21007 - receipt is for sandbox , but found in product environmet . // 收据信息是测试用（sandbox），但却被发送到产品环境中验证
    21008 - receipt is for product environment , but found in sandbox . // 收据信息是产品环境中使用，但却被发送到测试环境中验证
 */
