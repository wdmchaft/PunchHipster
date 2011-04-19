//
//  UpgradeViewController.h
//  PunchHipster
//
//  Created by David Patierno on 11/22/10.
//  Copyright 2010. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface UpgradeViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    id delegate;
    UIButton *upgradeButton;
    UILabel *priceLabel;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) IBOutlet UIButton *upgradeButton;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)done:(UIBarButtonItem *)button;
- (IBAction)upgrade:(UIButton *)button;

- (void)requestProductData;
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)restoreTransaction: (SKPaymentTransaction *)transaction;
- (void)failedTransaction: (SKPaymentTransaction *)transaction;
- (void)provideContent:(NSString *)productIdentifier;

@end
