//
//  ASReferral.h
//
//  Created by Justin Butler (justin@redline-labs.com)
//  Copyright (c) 2013 Red Line Labs, Inc.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

extern NSString *const kAppSpinAPIEndpoint;

extern NSString *const kAppSpinAppName;
extern NSString *const kAppSpinAppId;
extern NSString *const kAppSpinDeveloperToken;

@interface ASReferral : NSObject <UIAlertViewDelegate, NSURLConnectionDelegate>

- (void) checkForOffers;

@end