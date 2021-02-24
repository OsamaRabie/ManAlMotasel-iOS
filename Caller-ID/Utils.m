//
//  Utils.m
//  Caller-ID
//
//  Created by Osama Rabie on 2/24/21.
//  Copyright © 2021 SADAH Software Solutions, LLC. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+(BOOL)isVpnActive {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"]allKeys];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ipsec"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound){
            return YES;;
        }
    }
    return NO;
}

@end
