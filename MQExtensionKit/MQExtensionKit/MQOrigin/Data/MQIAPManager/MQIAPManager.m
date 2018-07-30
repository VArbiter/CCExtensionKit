//
//  CCIAPManager.m
//  MQExtensionKit
//
//  Created by ElwinFrederick on 04/05/2018.
//  Copyright © 2018 冯明庆. All rights reserved.
//

#import "CCIAPManager.h"

typedef NS_ENUM(NSInteger , CCIAPStatus) {
    CCIAPStatus_Purchase_Fail = 0,
    CCIAPStatus_Purchase_Success ,
    CCIAPStatus_Restore_Fail ,
    CCIAPStatus_Restore_Success
};

@interface CCIAPManager () < NSCopying , NSMutableCopying , SKPaymentTransactionObserver , SKProductsRequestDelegate >

@property (nonatomic , copy) void (^mq_result_block)(CCIAPManager *manager , id t , NSError *error) ;

- (void) mq_complete_transaction : (SKPaymentTransaction *) transaction
                          status : (CCIAPStatus) status ;

- (void) mq_upload_receipt : (SKPaymentTransaction *) transaction ;

@end

static CCIAPManager *__manager_IAP = nil;

@implementation CCIAPManager

static NSString *mq_IAP_error_domain = @"ElwinFrederick.CCIAPManager";

+ (instancetype) mq_shared {
    if (__manager_IAP) return __manager_IAP;
    __manager_IAP = [[CCIAPManager alloc] init];
    [SKPaymentQueue.defaultQueue addTransactionObserver:__manager_IAP];
    return __manager_IAP;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager_IAP = [[super allocWithZone:zone] init];
    });
    return __manager_IAP;
}

- (id)copyWithZone:(NSZone *)zone {
    return __manager_IAP;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return __manager_IAP;
}

#pragma mark - -----

- (void) mq_purchase : (NSString *) s_product_id {
    [self mq_purchase:s_product_id result:nil];
}
- (void) mq_purchase : (NSString *) s_product_id
              result : (void(^)(CCIAPManager *manager , id result , NSError *error)) mq_result_block {
    if (mq_result_block) self.mq_result_block = [mq_result_block copy];
    
    if ([SKPaymentQueue canMakePayments]) { // user allowed to purchase // 用户允许支付
        
        NSSet *set = [NSSet setWithObjects:s_product_id, nil];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
        
    } else {
        NSString *s_hint = @"please check if user allowed this device to use IAP or whether this device supported IAP .";
        NSError *e = [NSError errorWithDomain:mq_IAP_error_domain.copy
                                         code:-100001
                                     userInfo:@{ NSLocalizedDescriptionKey : s_hint }];
        
        if (self.mq_result_block) self.mq_result_block(self, nil, e);
        if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:error:)]) {
            [self.delegate mq_IAP_manager:self error:e];
        }
    }
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray <SKProduct *> *products = response.products;
    if (products.count == 0) {
        
        NSString *s_hint = @"invalid product info" ;
        NSError *e = [NSError errorWithDomain:mq_IAP_error_domain.copy
                                         code:-100002
                                     userInfo:@{ NSLocalizedDescriptionKey : s_hint }];
        if (self.mq_result_block) self.mq_result_block(self, nil, e);
        if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:error:)]) {
            [self.delegate mq_IAP_manager:self error:e];
        }
        return;
    }
    
    SKProduct *product = products.firstObject;
#if DEBUG
    NSLog(@"----- request product identifier:\n%@" , product.productIdentifier);
#endif
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [SKPaymentQueue.defaultQueue addPayment:payment];
}

- (void)requestDidFinish:(SKRequest *)request{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:request_did_finish:)]) {
        [self.delegate mq_IAP_manager:self request_did_finish:request];
    }
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    if (self.mq_result_block) self.mq_result_block(self, nil, error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:error:)]) {
        [self.delegate mq_IAP_manager:self error:error];
    }
}

#pragma mark - SKPaymentTransactionObserver
// observer payment status // 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
#if DEBUG
        NSLog(@"----- transaction identifier:\n%@" , transaction.transactionIdentifier);
#endif
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:break; // 0 , in payment transaction // 购买事务进行中
            case SKPaymentTransactionStatePurchased:{
                // 1 , payment transaction success // 交易完成
                [self mq_complete_transaction:transaction
                                       status:CCIAPStatus_Purchase_Success];
            }break;
            case SKPaymentTransactionStateFailed:{
                // 2 , payment transaction fail // 交易失败
                [self mq_complete_transaction:transaction
                                       status:CCIAPStatus_Purchase_Fail];
            }break;
            case SKPaymentTransactionStateRestored:{
                // 3 , restore payment transaction success , user has restored payment from history
                // 恢复交易成功 , 从用户的购买历史中恢复了交易
                [self mq_complete_transaction:transaction
                                       status:CCIAPStatus_Restore_Success];
            }break;
            case SKPaymentTransactionStateDeferred:{
                // 4 , purchase failed , destory payment transaction // 购买失败 , 销毁交易
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
            }break;
            default:{
                // finish payment transaction // 结束支付事务
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
            }break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
#if DEBUG
    for(SKPaymentTransaction *transaction in transactions){
        NSLog(@" ----- payment queue was removed : \n %@", transaction.payment.productIdentifier);
    }
#endif
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:payment_queue:removed:)]) {
        [self.delegate mq_IAP_manager:self
                        payment_queue:queue
                              removed:transactions];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(mq_IAP_manager:payment_queue:restore_completed_fail:)]) {
        [self.delegate mq_IAP_manager:self payment_queue:queue restore_completed_fail:error];
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:restore_completed:)]) {
        [self.delegate mq_IAP_manager:self restore_completed:queue];
    }
}

#pragma mark - -----
- (void) mq_complete_transaction : (SKPaymentTransaction *) transaction
                          status : (CCIAPStatus) status {
    // don't sent any notify when user cancel the purchase // 用户取消是不发送任何通知 .
    if (transaction.error.code != SKErrorPaymentCancelled){
        switch (status) {
            case CCIAPStatus_Purchase_Success:
            case CCIAPStatus_Restore_Success:{
                [self mq_upload_receipt:transaction];
            }break;
            case CCIAPStatus_Purchase_Fail:
            case CCIAPStatus_Restore_Fail:
            default:{
                if(self.mq_result_block) self.mq_result_block(self, nil, transaction.error) ;
                if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:error:)]) {
                    [self.delegate mq_IAP_manager:self error:transaction.error];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction]; // finish payment transaction // 结束支付事务
            }break;
        }
    } else {
        
        NSString *s_hint = @"user cancelled purchase payment.";
        NSError *e = [NSError errorWithDomain:mq_IAP_error_domain.copy
                                         code:-100003
                                     userInfo:@{ NSLocalizedDescriptionKey : s_hint }];
        if(self.mq_result_block) self.mq_result_block(self, nil, e) ;
        if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:error:)]) {
            [self.delegate mq_IAP_manager:self error:e];
        }
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction]; // finish payment transaction // 结束支付事务
        
    }
}

// https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html
// apple check address // 官方校验地址
- (void) mq_upload_receipt : (SKPaymentTransaction *) transaction {
    NSURL *url_receipt = [NSBundle.mainBundle appStoreReceiptURL];
    NSData *data_receipt = [NSData dataWithContentsOfURL:url_receipt];
    if (!data_receipt) {
#if DEBUG
        NSLog(@"----- no local receipt."); // no local .// 本地数据不存在
#endif
        return;
    }
    NSString *s_base64_receipt = [data_receipt base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *d_params = [NSMutableDictionary dictionary];
    [d_params setObject:s_base64_receipt forKey:CC_IAP_PARAMS_RECEIPT_KEY];
    [d_params setObject:transaction.transactionIdentifier forKey:CC_IAP_PARAMS_TRANSACTION_ID_KEY];
    
    if (self.mq_upload_receipt_block) {
        if (self.mq_upload_receipt_block(self, url_receipt, d_params)) {
            [SKPaymentQueue.defaultQueue finishTransaction:transaction];
        };
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mq_IAP_manager:original_url:final_result:)]) {
        if ([self.delegate mq_IAP_manager:self original_url:url_receipt final_result:d_params]) {
            [SKPaymentQueue.defaultQueue finishTransaction:transaction];
        }
    }
}

- (void) dealloc {
#if DEBUG
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
#endif
    [SKPaymentQueue.defaultQueue removeTransactionObserver:self];
}

@end

CCIAPParamsKey CC_IAP_PARAMS_RECEIPT_KEY = @"receipt" ;
CCIAPParamsKey CC_IAP_PARAMS_TRANSACTION_ID_KEY = @"transaction_id" ;
