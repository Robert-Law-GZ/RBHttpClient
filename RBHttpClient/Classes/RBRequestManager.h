//
//  SBAPIManager.h
//  AFNSample
//

#define  HTTP_POST              @"POST"
#define  HTTP_GET               @"GET"
#define  HTTP_PATCH             @"PATCH"
#define  HTTP_PUT               @"PUT"
#define  HTTP_DELETE            @"DELETE"
#define  HTTP_HEAD              @"HEAD"

#import <AFNetworking/AFNetworking.h>


@interface RBRequestManager : AFHTTPSessionManager

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT BOOL  SHOW_HTTP_LOG;

+(void)configAFN;

+(NSString *)paramSortToString:(id)parameters;

- (instancetype)initWithBaseURL:(nullable NSURL *)url;


-(void)setUsername:(NSString *)username andPassword:(NSString *)password;

- (NSURLSessionDataTask *)GET:(NSString*)host
                    apiSuffix:(NSString *)apiSuffix
                       params:(nullable id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString*)host
                     apiSuffix:(NSString *)apiSuffix
                         params:(nullable id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)UPLOAD:(NSString*)host
                       apiSuffix:(NSString *)apiSuffix
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)PUT:(NSString*)host
                    apiSuffix:(NSString *)apiSuffix
                         params:(nullable id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)PATCH:(NSString*)host
                      apiSuffix:(NSString *)apiSuffix
                         params:(nullable id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)DELETE:(NSString*)host
                       apiSuffix:(NSString *)apiSuffix
                         params:(nullable id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(NSURLSessionDataTask *)buildSessionDataTaskWithMethod:(NSString *)host method:(NSString *)method apiSuffix:(NSString *)apiSuffix params:(id)parameters
                                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)buildSessionDataTaskWithHost:(NSString *)host method:(NSString *)method apiSuffix:(NSString *)apiSuffix params:(id)parameters
                                              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

NS_ASSUME_NONNULL_END

@end
