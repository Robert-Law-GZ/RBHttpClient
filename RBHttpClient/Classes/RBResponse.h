//
//  SWTResponse.h
//  SWTIOSFramework
//
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBResponse : NSObject
    //    {
    //        "result": true,
    //        "data": "",
    //        "msg": "操作成功",
    //        "code": 0,
    //    }
    
    @property(nonatomic,assign)Boolean result;
    @property(nonatomic,assign)NSInteger code;
    @property(nonatomic,strong)NSDictionary *data;
    @property(nonatomic,copy)NSString *msg;
    
    @property(nonatomic,copy)NSString *apiSuffix;
    @property(nonatomic,copy)NSString *method;
    
-(BOOL)isExecuteSuccess;
-(BOOL)matchAPISuffix:(NSString *)apiSuffix method:(NSString *)method;
    
@end
