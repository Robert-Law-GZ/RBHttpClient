//
//  UIViewController+THZRequestClient.m
//  RBHttpClient_Example
//
//  Created by Robert on 2019/6/9.
//  Copyright © 2019 Robert-Law-GZ. All rights reserved.
//

#import "UIViewController+THZRequestClient.h"
#import <RSAUtil.h>

@implementation UIViewController (THZRequestClient)

-(NSURLSessionDataTask *)buildPOSTRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildPOSTRequest:[self handlerToken] host:HTTP_HOST apiSuffix:apiSuffix withParams:[self handlerParams:params]];
}


-(RBRequestManager *)handlerToken{
    RBRequestManager *manager=[RBRequestManager manager];
    [manager.requestSerializer setValue:@"tokenkadkasdkfaskfskfsd" forHTTPHeaderField:@"token"];
    return manager;
}


-(NSDictionary *)handlerParams:(NSDictionary *)params{
    if (params==nil) {
        params=[NSDictionary dictionary];
    }
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    NSString *timestamp=[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    [dict setValue:timestamp forKey:@"request_time"];
    
    NSString *ss=[RBRequestManager paramSortToString:dict];
    NSString *sign=[RSAUtil encryptString:ss publicKey:PUBLIC_KEY];
    
    [dict setValue:sign forKey:@"apisign"];
    
    return dict;
}

-(NSURLSessionDataTask *)buildGETRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return nil;
}

-(NSURLSessionDataTask *)buildPATCHRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return nil;
}

-(NSURLSessionDataTask *)buildPUTRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return nil;
}

-(NSURLSessionDataTask *)buildDELETERequest:(NSString *)apiSuffix withParams:(NSDictionary *)params{
   return nil;
}

@end
