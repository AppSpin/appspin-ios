//
//  ASReferral.m
//
//  Created by Justin Butler (justin@redline-labs.com)
//  Copyright (c) 2013 Red Line Labs, Inc.
//

#import "ASReferral.h"

@interface ASReferral()

- (void)errorHandler: (NSString *)error showAlert: (BOOL)shouldAlert;
- (void)presentOffer;
- (void)launchReward;

@property NSMutableData *responseData;
@property NSString *campaignInfoLink;

@end


NSString *const kAppSpinAPIEndpoint = @"http://api.appsp.in/";

NSString *const kAppSpinAppName = @"ExampleApp";                  // YOUR APP NAME GOES HERE
NSString *const kAppSpinAppId = @"4";                             // YOUR APP ID GOES HERE (FROM APP DASHBOARD)
NSString *const kAppSpinDeveloperToken = YOUR_DEVELOPER_TOKEN;    // YOUR DEVELOPER TOKEN GOES HERE (FROM MAIN MENU)


@implementation ASReferral

- (void)checkForOffers {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@campaigns?app_id=%@&token=%@",
                    kAppSpinAPIEndpoint,
                    kAppSpinAppId,
                    kAppSpinDeveloperToken]];
    
    // async request for campaign data
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLCacheStorageNotAllowed
                                                timeoutInterval:60.0];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    #pragma unused(conn)
    
    return;
}


/*
 * This simple example uses a system dialog to present the offer
 * Modify to display a native modal container with a more stylized / branded appearance
 */
- (void)presentOffer {
    
    // YOUR OFFER MESSAGE GOES HERE
    NSString *message = [NSString stringWithFormat:@"Would you like to earn rewards by sharing %@?", kAppSpinAppName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Earn Rewards!"
                                            message:message
                                            delegate:self
                                            cancelButtonTitle:@"Learn More"
                                            otherButtonTitles:@"Yes, please!", @"No, thanks", nil];
    [alert show];
    
    return;
}

- (void)launchReward {
    if (_campaignInfoLink) {
        /*
         * Launch browser to display campaign details
         *
         * If you want to display the details natively, you make make
         * a request for JSON data via the API's "info" endpoint
         * TODO: link to API docs
         */
        
        NSURL *url = [NSURL URLWithString:_campaignInfoLink];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    return;
}


#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if(![title isEqualToString:@"No, thanks"])
    {
        /*
         * If your app already has the user's contact info, you can generate affiliate
         * links on the fly via the API's "generate" endpoint
         * TODO: link to API docs
         */
        [self launchReward];
    }
    
    return;
}


#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // response was received, so get ready to collect data
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // append the new data to _responseData as it comes in
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // not desirable to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // request is complete
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:_responseData
                                              options:kNilOptions
                                              error:&error];
    if (error) {
        [self errorHandler:[error localizedDescription] showAlert:NO];
    }
    
    if ([json objectForKey:@"error"]) {
        [self errorHandler:[json objectForKey:@"error"] showAlert:NO];
    }
    
    NSDictionary* data = [json objectForKey:@"data"];
    
    if ([data objectForKey:@"campaigns"]) {
        NSArray* campaigns = [data objectForKey:@"campaigns"];
        if ([campaigns count]>0) {
            /*
             * Here we just grab the first campaign,
             * but we could write business logic to choose a specific campaign
             * TODO: provide example of server-side implementation of business logic
             */
            NSString *infoLink = [[campaigns objectAtIndex:0] objectForKey:@"info_link"];
            
            if (![infoLink hasPrefix:@"http"]) {
                infoLink = [NSString stringWithFormat:@"http://%@", infoLink];
            }
            
            _campaignInfoLink = infoLink;
            [self presentOffer];
        } else {
            [self errorHandler:@"There are currently no offers available" showAlert:NO];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // request has failed
    [self errorHandler:[error localizedDescription] showAlert:NO];
}


#pragma mark error handling

- (void)errorHandler: (NSString *)error showAlert: (BOOL)shouldAlert {
    NSLog(@"%@", error);
    if (shouldAlert) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return;
}

@end
