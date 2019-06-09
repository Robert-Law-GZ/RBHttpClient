//
//  UIViewController+HTTPRequest.h
//
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EWGResponse.h"
#import "EWGRequestManager.h"

@interface UIViewController (HTTPRequest)

-(NSURLSessionDataTask *)buildPOSTRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildGETRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPATCHRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPUTRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildDELETERequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildRequest:(NSString *) host method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildUpload:(NSString *) host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withData:(NSData *)imageData;

-(NSURLSessionDataTask *)buildUpload:(NSString *) host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withImage:(UIImage *)image;

-(NSURLSessionDataTask *)buildGETWithHost:(NSString *)host request:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildReqWithHost:(NSString *)host method:(NSString *)method request:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(void)requestStart:(NSString *)task;
-(void)requestSuccess:(NSURLSessionDataTask *)task withResponse:(EWGResponse *)response;
-(void)requestProgress:(NSURLSessionDataTask *)task withProgress:(NSProgress *)progress;
-(void)requestFailure:(NSURLSessionDataTask *)task withResponse:(EWGResponse *)response;


@end
