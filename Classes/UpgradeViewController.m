//
//  UpgradeViewController.m
//  PunchHipster
//
//  Created by David Patierno on 11/22/10.
//  Copyright 2010. All rights reserved.
//

#import "UpgradeViewController.h"
#import "SplashViewController.h"

@implementation UpgradeViewController

@synthesize delegate, upgradeButton, priceLabel, spinner;

static NSString *kUpgrade = @"com.dmpatierno.punchahipster.upgrade";

- (IBAction)done:(UIBarButtonItem *)button {
    // Just cancel if the user doesn't have permissions.
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"upgrade"]) {
        
    }
    // Close the modal.
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)upgrade:(UIButton *)button {
    if (priceLabel.hidden) {
        [self requestProductData];
    }
    else {
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:kUpgrade];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
	upgradeButton.enabled = NO;
    [spinner startAnimating];
    spinner.hidden = NO;
}

- (void)requestProductData {
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kUpgrade]];
	request.delegate = self;
	[request start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;

	if ([myProduct count]) {
		SKProduct *product = [myProduct lastObject];
		if ([product.productIdentifier isEqual:kUpgrade]) {
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:product.priceLocale];
            NSString *formattedString = [numberFormatter stringFromNumber:product.price];
            [numberFormatter release];
            
            priceLabel.text = [NSString stringWithFormat:@"%@ in-app purchase", formattedString];
            upgradeButton.enabled = YES;
            priceLabel.hidden = NO;
            [spinner stopAnimating];
            
        }
	}
    
	[request autorelease];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction {
    //[self recordTransaction: transaction];
    [self provideContent:transaction.payment.productIdentifier];
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction {
    //[self recordTransaction: transaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction {
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[transaction.error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];        
    }
	
	upgradeButton.enabled = YES;
    [spinner stopAnimating];
	
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView release];
}

- (void)provideContent:(NSString *)productIdentifier {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"upgrade"];
	[prefs synchronize];
    
    // TODO: load picker
    
    [spinner stopAnimating];
    [self done:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self requestProductData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (priceLabel.hidden)
        [self requestProductData];   
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
