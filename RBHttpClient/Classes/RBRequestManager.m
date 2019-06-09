//
//  SBAPIManager.m
//  AFNSample
//

#import "RBRequestManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation RBRequestManager

BOOL  SHOW_HTTP_LOG=YES;

+(void)configAFN{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self=[super initWithBaseURL:url];
    
    if (self) {
        //申明返回的结果是json类型
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        self.requestSerializer=[AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval=10;
    }
    
    return self;
}

-(void)setUsername:(NSString *)username andPassword:(NSString *)password{
    //    [self.requestSerializer clearAuthorizationHeader];
    //    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}


- (NSURLSessionDataTask *)GET:(NSString*)host
                    apiSuffix:(NSString *)apiSuffix
                       params:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithMethod:host
                                         method:HTTP_GET
                                      apiSuffix:apiSuffix
                                         params:parameters
                                        success:success
                                        failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString*)host
                     apiSuffix:(NSString *)apiSuffix
                        params:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithMethod:host
                                         method:HTTP_POST
                                      apiSuffix:apiSuffix
                                         params:parameters
                                        success:success
                                        failure:failure];
}

- (NSURLSessionDataTask *)UPLOAD:(NSString*)host
                       apiSuffix:(NSString *)apiSuffix
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    NSString *url=[NSString stringWithFormat:@"%@/%@",host,apiSuffix];
    
    self.requestSerializer.timeoutInterval=60;
    
    if ([apiSuffix hasPrefix:@"/"]) {
        url=[NSString stringWithFormat:@"%@%@",host,apiSuffix];
    }
    
    NSURLSessionDataTask *task=[self POST:url parameters:parameters
                constructingBodyWithBlock:block
                                 progress:uploadProgress
                                  success:success
                                  failure:failure];
    
    [self printLog:task widthParams:parameters];
    
    return task;
}


- (NSURLSessionDataTask *)DELETE:(NSString*)host
                       apiSuffix:(NSString *)apiSuffix
                          params:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithMethod:host
                                         method:HTTP_DELETE
                                      apiSuffix:apiSuffix
                                         params:parameters
                                        success:success
                                        failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString*)host
                    apiSuffix:(NSString *)apiSuffix
                       params:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithMethod:host
                                         method:HTTP_PUT
                                      apiSuffix:apiSuffix
                                         params:parameters
                                        success:success
                                        failure:failure];
}

- (NSURLSessionDataTask *)PATCH:(NSString*)host
                      apiSuffix:(NSString *)apiSuffix
                         params:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithMethod:host
                                         method:HTTP_PATCH
                                      apiSuffix:apiSuffix
                                         params:parameters
                                        success:success
                                        failure:failure];
}

- (NSURLSessionDataTask *)buildSessionDataTaskWithHost:(NSString *)host
                                                method:(NSString *)method
                                             apiSuffix:(NSString *)apiSuffix
                                                params:(id)parameters
                                               success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success
                                               failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
    
    NSString *httpMethod=[method uppercaseString];
    NSString *url=[NSString stringWithFormat:@"%@/%@",host,apiSuffix];
    
    if ([apiSuffix hasPrefix:@"/"]) {
        url=[NSString stringWithFormat:@"%@%@",host,apiSuffix];
    }
    
    NSURLSessionDataTask *task=nil;
    
    if ([httpMethod isEqualToString:HTTP_POST]) {
        task=[super POST:url parameters:parameters progress:nil success:success  failure:failure];
    }else if([httpMethod isEqualToString:HTTP_GET]){
        task=[super GET:url parameters:parameters progress:nil success:success  failure:failure];
    }else if([httpMethod isEqualToString:HTTP_PATCH]){
        task=[super PATCH:url parameters:parameters success:success  failure:failure];
    }else if([httpMethod isEqualToString:HTTP_DELETE]){
        task=[super DELETE:url parameters:parameters success:success  failure:failure];
    }else if([httpMethod isEqualToString:HTTP_PUT]){
        task=[super PUT:url parameters:parameters success:success  failure:failure];
    }

    [self printLog:task widthParams:parameters];
    
    return task;
    
}

- (NSString *)URLEncodedWithString:(NSString *)urlStr{
    NSString *unencodedString = urlStr;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

-(NSURLSessionDataTask *)buildSessionDataTaskWithMethod:(NSString *)host method:(NSString *)method
                                              apiSuffix:(NSString *)apiSuffix
                                                 params:(id)parameters
                                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    return [self buildSessionDataTaskWithHost:host
                                       method:method
                                    apiSuffix:apiSuffix
                                       params:parameters
                                      success:success
                                      failure:failure];
}


-(void)printLog:(NSURLSessionDataTask *)task widthParams:(id)params{
    
    if (task!=nil) {
        NSString* urlString=[[[task currentRequest] URL] absoluteString];
        NSString *httpMethod=[[task currentRequest] HTTPMethod];
       NSDictionary *headers=[[task currentRequest] allHTTPHeaderFields];
        
        NSString *reqLog=@"\n";
        reqLog=[reqLog stringByAppendingString:@"--------------------start-----------------------\n"];
        reqLog=[reqLog stringByAppendingString:[NSString stringWithFormat:@"URL: %@\n",urlString]];
        reqLog=[reqLog stringByAppendingString:[NSString stringWithFormat:@"Method: %@\n",httpMethod]];
        reqLog=[reqLog stringByAppendingString:[NSString stringWithFormat:@"Body: \n%@\n",params]];
        reqLog=[reqLog stringByAppendingString:[NSString stringWithFormat:@"Header:\n%@\n",headers.description]];
        reqLog=[reqLog stringByAppendingString:@"--------------------end-------------------------"];
        
        if (SHOW_HTTP_LOG) {
            NSLog(@"%@",reqLog);
        }
        
    }
}


+(NSString *)paramSortToString:(id)parameters{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (parameters) {
        [params addEntriesFromDictionary:parameters];
    }
    
    NSArray *keyArray = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *paramsString = @"";
    
    for (int index = 0; index < keyArray.count; index++) {
        NSString *key = [keyArray objectAtIndex:index];
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[@(YES) class]]) {
            if ([value boolValue] == YES) {
                value = @1;
            } else if ([value boolValue] == NO) {
                value = @0;
            }
        }
        
        if ([value isKindOfClass:[NSString class]]){
            paramsString = [paramsString stringByAppendingFormat:@"%@", value];
        } else if ([value respondsToSelector:@selector(stringValue)]){
            paramsString = [paramsString stringByAppendingFormat:@"%@", [value stringValue]];
        }
    }

    return paramsString;
}


@end
