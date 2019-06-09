//
//  SWTResponse.h
//  SWTIOSFramework
//
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBResponse : NSObject

@property(nonatomic,strong)id result;

@property(nonatomic,copy)NSString *apiSuffix;
@property(nonatomic,copy)NSString *method;

-(BOOL)matchAPISuffix:(NSString *)apiSuffix method:(NSString *)method;

@end
