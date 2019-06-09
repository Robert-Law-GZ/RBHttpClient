//
//  UIViewController+THZRequestClient.h
//  RBHttpClient_Example
//
//  Created by Robert on 2019/6/9.
//  Copyright © 2019 Robert-Law-GZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define PUBLIC_KEY @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApRy27BzzUVRmeWjlktTfzsJN4wPJ70vL2hyl7mBsEZS7BFZyDA2lWe4WjfnqGAuoEyz7MiAI3hXYaO3NLrQOniG4EShQyBg8hZl36QDzZFCqxtn7F+0yvp74SmLUzkVFutlLHq2iAs58c/bDGAkJsT5CW/NGvPzwd0zbV+W07SYQg2QyLvk94LxhMi70yY/Jk5dn6d4NwmknFmVjjDEDULavcIpDul8blpT8Lk1TCsArqOLIczYACNGNQyz0xXKmtW0As+JgaCfwrEbME6x8m7r/yKJLiwTESMyU+IbpHIJV40VP9gx9eqrZoRS3NVmyiElUA2d4HdF29tfIhEaZ2wIDAQAB"

#define HTTP_HOST @"http://dev.tehuizhuan.com:8088"

@interface UIViewController (THZRequestClient)
-(NSURLSessionDataTask *)buildPOSTRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildGETRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPATCHRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildPUTRequest:(NSString *)apiSuffix withParams:(NSDictionary *)params;

-(NSURLSessionDataTask *)buildDELETERequest:(NSString *)apiSuffix withParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
