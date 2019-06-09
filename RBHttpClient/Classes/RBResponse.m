//
//  SWTResponse.m
//  SWTIOSFramework
//
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//

#import "RBResponse.h"

@implementation RBResponse


-(BOOL)matchAPISuffix:(NSString *)apiSuffix method:(NSString *)method{
    return ([_apiSuffix isEqualToString:apiSuffix]&&[self.method isEqualToString:method]);
}


@end
