//
//  UIViewController_RequestExceptioin.h
//  Pods
//
//  Created by Lo Robert on 2017/9/15.
//
//

#import <UIKit/UIKit.h>
#import "EWGResponse.h"

@interface UIViewController ()

-(void)onKick:(EWGResponse *)response;
-(void)onAccessDenied:(EWGResponse *)response;

@end
