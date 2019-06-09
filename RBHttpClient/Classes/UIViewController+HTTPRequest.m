//
//  UIViewController+HTTPRequest.m
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//

#import "UIViewController+HTTPRequest.h"
#import "RBResponse.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "RBImageCompress.h"
#import <MJExtension/MJExtension.h>

#define  k_Progress_View_tag            100000
#define  k_Progress_View_loding_tag     100001

#ifdef DEBUG
//#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif

@implementation UIViewController (HTTPRequest)

-(NSURLSessionDataTask *)buildPOSTRequest:(RBRequestManager *)manager host:(NSString *) host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:manager host:host method:HTTP_POST apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildGETRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:manager host:host method:HTTP_GET apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildPATCHRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:manager host:host method:HTTP_PATCH apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildPUTRequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:manager host:host method:HTTP_PUT apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildDELETERequest:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:manager host:host method:HTTP_DELETE apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildRequest:(RBRequestManager *)manager host:(NSString *)host method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequestWithMethod:manager host:host method:method apiSuffix:apiSuffix withParams:params];
}

-(NSURLSessionDataTask *)buildReqWithHost:(RBRequestManager *)manager host:(NSString *)host method:(NSString *)method request:(NSString *)apiSuffix withParams:(NSDictionary *)params{

    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *task=[manager buildSessionDataTaskWithHost:host
                                                              method:method
                                                           apiSuffix:apiSuffix
                                                              params:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 RBResponse *response=[self handlerResponse:task suffix:apiSuffix resp:responseObject];
                                                                 [weakSelf requestSuccess:task withResponse:response];
                                                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 RBResponse *response=[[RBResponse alloc] init];
                                                                 [response setMethod:method];
                                                                 [response setApiSuffix:apiSuffix];

                                                                 [weakSelf requestFailure:task withResponse:response];
                                                             }];
    [self requestStart:apiSuffix];
    return task;
}


-(RBResponse *)handlerResponse:(NSURLSessionDataTask *)task suffix:(NSString*)suffix resp:(id) responseObject{
    RBResponse *response=[RBResponse mj_objectWithKeyValues:responseObject];
    [response setResult:responseObject];
    [response setApiSuffix:suffix];
    [response setMethod:[[task currentRequest] HTTPMethod]];
    return response;
}


- (NSURLSessionDataTask *)buildRequestWithMethod:(RBRequestManager *)manager host:(NSString*)host
                                       method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *task=[manager buildSessionDataTaskWithHost:host
                                                              method:method
                                                           apiSuffix:apiSuffix
                                                              params:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 
                                                                 RBResponse *response=[self handlerResponse:task suffix:apiSuffix resp:responseObject];
                                                                 
                                                                 [self hiddenLoading];
                                                                [weakSelf requestSuccess:task withResponse:response];
                 
                                                                 if (SHOW_HTTP_LOG) {
                                                                     NSLog(@"请求成功:\n%@",[responseObject description]);
                                                                 }
                                                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 [self hiddenLoading];
                                                                 RBResponse *response=[[RBResponse alloc] init];
                                                                 [response setApiSuffix:apiSuffix];
                                                                  [response setMethod:method];
                                                                 [weakSelf requestFailure:task withResponse:response];
                                                             }];
    [self requestStart:apiSuffix];
    return task;
}

-(NSURLSessionDataTask *)buildUpload:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withData:(NSData *)imageData{
    
    __weak __typeof(self)weakSelf = self;
    __block NSURLSessionDataTask *task=[manager UPLOAD:host apiSuffix:apiSuffix parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf requestProgress:task withProgress:uploadProgress];
        });
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        RBResponse *response=[RBResponse mj_objectWithKeyValues:responseObject];
        [response setApiSuffix:apiSuffix];
        [response setMethod:[[task currentRequest] HTTPMethod]];
        
        if (SHOW_HTTP_LOG) {
            NSLog(@"上传成功:\n%@",response.result);
        }
        
        [self hiddenLoading];
        [weakSelf requestSuccess:task withResponse:response];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        RBResponse *response=[[RBResponse alloc] init];
        [response setApiSuffix:apiSuffix];
        [response setMethod:[[task currentRequest] HTTPMethod]];
        [weakSelf requestFailure:task withResponse:response];
        [self hiddenLoading];
    }];
    
    [task setTaskDescription:tag];
    
    return task;
}


-(void)hiddenLoading{
     MBProgressHUD *hud=[self.view viewWithTag:k_Progress_View_loding_tag];
    if(hud){
        [hud hideAnimated:YES];
    }
}

-(void)hiddenProgress:(UIViewController *)viewController msg:(NSString *)msg afterDeley:(BOOL) isDeley{
    MBProgressHUD *hud=[viewController.view viewWithTag:k_Progress_View_tag];
    
    if(hud==nil){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    hud.mode=MBProgressHUDModeText;
    hud.label.text=msg;
    [hud showAnimated:YES];
    
    if (isDeley) {
        [hud hideAnimated:YES afterDelay:2];
    }else{
        [hud hideAnimated:YES];
    }
}

-(NSURLSessionDataTask *)buildUpload:(RBRequestManager *)manager host:(NSString *)host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withImage:(UIImage *)image{
    NSData *data=[RBImageCompress compressWithImage:image];
    return [self buildUpload:manager host:host apiSuffix:apiSuffix withTag:tag withParams:params withData:data];
}


- (NSURLSessionDataTask *)buildGETWithHost:(RBRequestManager *)manager host:(NSString *)host request:(NSString *)apiSuffix withParams:(NSDictionary *)params {
    NSURLSessionDataTask *task=[self buildRequestWithMethod:manager host:host method:@"GET" apiSuffix:apiSuffix withParams:params];
    return task;
}


-(void)requestStart:(NSString *)apiSuffix{
    MBProgressHUD *hud=[self.view viewWithTag:k_Progress_View_loding_tag];
    
    if(hud==nil){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDModeIndeterminate;
        [hud setTag:k_Progress_View_loding_tag];
        hud.label.numberOfLines=0;
    }
    
    [hud showAnimated:YES];
}


-(void)requestProgress:(NSURLSessionDataTask *)task withProgress:(NSProgress *)progress{
    
}

-(void)requestSuccess:(NSURLSessionDataTask *)task withResponse:(RBResponse *)response{
    [self hiddenProgress:self msg:@"成功了" afterDeley:NO];
}

-(void)requestFailure:(NSURLSessionDataTask *)task withResponse:(RBResponse *)response{
    [self hiddenProgress:self msg:@"失败了" afterDeley:YES];
}

@end
