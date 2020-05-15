//
//  UIViewController+iOS13Fixes.m
//  Caller-ID
//
//  Created by Osama Rabie on 26/04/2020.
//  Copyright © 2020 SADAH Software Solutions, LLC. All rights reserved.
//

#import "UIViewController+iOS13Fixes.h"
#import <objc/runtime.h>

@implementation UIViewController (iOS13Fixes)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(swizzled_presentViewController:animated:completion:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL methodExists = !class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

        if (methodExists) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        } else {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
    });
}

- (void)swizzled_presentViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {

    if (@available(iOS 13.0, *)) {
        if (viewController.modalPresentationStyle == UIModalPresentationAutomatic || viewController.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }

    [self swizzled_presentViewController:viewController animated:animated completion:completion];
}

@end
