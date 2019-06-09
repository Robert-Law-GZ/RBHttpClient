//
//  UIViewController+HTTPRequest.h
//
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RBResponse.h"
#import "RBRequestManager.h"

@interface UIViewController (HTTPRequest)

-(NSURLSessionDataTask *)buildPOSTRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildGETRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPATCHRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPUTRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildDELETERequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildRequest:(RBRequestManager *)manager host:(NSString *) host method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildUpload:(RBRequestManager *)manager host:(NSString *) host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withData:(NSData *)imageData;

-(NSURLSessionDataTask *)buildUpload:(RBRequestManager *)manager host:(NSString *) host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withImage:(UIImage *)image;

-(NSURLSessionDataTask *)buildGETWithHost:(RBRequestManager *)manager host:(NSString *)host request:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildReqWithHost:(RBRequestManager *)manager host:(NSString *)host method:(NSString *)method request:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(void)requestStart:(NSString *)task;
-(void)requestSuccess:(NSURLSessionDataTask *)task withResponse:(RBResponse *)response;
-(void)requestProgress:(NSURLSessionDataTask *)task withProgress:(NSProgress *)progress;
-(void)requestFailure:(NSURLSessionDataTask *)task withResponse:(RBResponse *)response;


@end
