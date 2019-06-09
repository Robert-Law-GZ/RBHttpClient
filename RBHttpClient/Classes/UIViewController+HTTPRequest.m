//
//  UIViewController+HTTPRequest.m
//  Created by Lo Robert on 2017/6/15.
//  Copyright © 2017年 SWT. All rights reserved.
//

#import "UIViewController+HTTPRequest.h"
#import "EWGResponse.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController_RequestException.h"
#import "EWGImageCompress.h"
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

-(NSURLSessionDataTask *)buildPOSTRequest:(NSString *) host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:host method:HTTP_POST apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildGETRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:host method:HTTP_GET apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildPATCHRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:host method:HTTP_PATCH apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildPUTRequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:host method:HTTP_PUT apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildDELETERequest:(NSString *)host apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequest:host method:HTTP_DELETE apiSuffix:apiSuffix withParams:params];
}


-(NSURLSessionDataTask *)buildRequest:(NSString *)host method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    return [self buildRequestWithMethod:host method:method apiSuffix:apiSuffix withParams:params];
}

-(NSURLSessionDataTask *)buildReqWithHost:(NSString *)host method:(NSString *)method request:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    EWGRequestManager *manager=[EWGRequestManager manager];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *task=[manager buildSessionDataTaskWithHost:host
                                                              method:method
                                                           apiSuffix:apiSuffix
                                                              params:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 
                                                                 EWGResponse *response=[self handlerResponse:task suffix:apiSuffix resp:responseObject];
                                                                 
                                                                 [weakSelf requestSuccess:task withResponse:response];
                                                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 EWGResponse *response=[[EWGResponse alloc] init];
                                                                 [response setCode:-1];
                                                                 [response setMethod:method];
                                                                 [response setApiSuffix:apiSuffix];
                                                                 [response setMsg:@"网络异常，请稍候再试！"];
                                                                 
                                                                 [weakSelf requestFailure:task withResponse:response];
                                                             }];
    [self requestStart:apiSuffix];
    return task;
}


-(EWGResponse *)handlerResponse:(NSURLSessionDataTask *)task suffix:(NSString*)suffix resp:(id) responseObject{
    EWGResponse *response=[EWGResponse mj_objectWithKeyValues:responseObject];
    [response setData:responseObject];
    
    [response setApiSuffix:suffix];
    [response setMethod:[[task currentRequest] HTTPMethod]];
    
    return response;
}


- (NSURLSessionDataTask *)buildRequestWithMethod:(NSString*)host
                                       method:(NSString *)method apiSuffix:(NSString *)apiSuffix withParams:(NSDictionary *)params{
    EWGRequestManager *manager=[EWGRequestManager manager];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *task=[manager buildSessionDataTaskWithHost:host
                                                              method:method
                                                           apiSuffix:apiSuffix
                                                              params:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 
                                                                 EWGResponse *response=[self handlerResponse:task suffix:apiSuffix resp:responseObject];
                                                                 [self hiddenLoading];
                                                                 if (response.isExecuteSuccess) {
                                                                     [weakSelf requestSuccess:task withResponse:response];
                                                                 }else{
                                                                     [weakSelf requestFailure:task withResponse:response];
                                                                 }
                                                                 
                                                                 if (SHOW_HTTP_LOG) {
                                                                     NSLog(@"请求成功:\n%@",[responseObject description]);
                                                                 }
                                                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 EWGResponse *response=[[EWGResponse alloc] init];
                                                                 [response setCode:-1];
                                                                 [response setApiSuffix:apiSuffix];
                                                                 [response setMethod:method];
                                                                 [response setMsg:@"网络异常，请稍候再试！"];
                                                                 
                                                                 [self hiddenLoading];
                                                                 [weakSelf requestFailure:task withResponse:response];
                                                             }];
    [self requestStart:apiSuffix];
    return task;
}

-(NSURLSessionDataTask *)buildUpload:(NSString *)host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withData:(NSData *)imageData{
    EWGRequestManager *manager=[EWGRequestManager manager];
    
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
        EWGResponse *response=[EWGResponse mj_objectWithKeyValues:responseObject];
        [response setApiSuffix:apiSuffix];
        [response setMethod:[[task currentRequest] HTTPMethod]];
        
        if (SHOW_HTTP_LOG) {
            NSLog(@"上传成功:\n%@",response.data);
        }
        
        [self hiddenLoading];
        [weakSelf requestSuccess:task withResponse:response];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        EWGResponse *response=[[EWGResponse alloc] init];
        [response setCode:-1];
        [response setApiSuffix:apiSuffix];
        [response setMethod:[[task currentRequest] HTTPMethod]];
        [response setMsg:@"网络异常，请稍候再试！"];
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

-(NSURLSessionDataTask *)buildUpload:(NSString *)host apiSuffix:(NSString *)apiSuffix withTag:(NSString *)tag withParams:(NSDictionary *)params withImage:(UIImage *)image{
    NSData *data=[EWGImageCompress compressWithImage:image];
    return [self buildUpload:host apiSuffix:apiSuffix withTag:tag withParams:params withData:data];
}


- (NSURLSessionDataTask *)buildGETWithHost:(NSString *)host request:(NSString *)apiSuffix withParams:(NSDictionary *)params {
    NSURLSessionDataTask *task=[self buildRequestWithMethod:host method:@"GET" apiSuffix:apiSuffix withParams:params];
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


-(void)requestSuccess:(NSURLSessionDataTask *)task withResponse:(EWGResponse *)response{
    [self hiddenProgress:self msg:@"" afterDeley:NO];
    
    if (response.isExecuteSuccess) {
        
    }else{
        if (SHOW_HTTP_LOG) {
            NSLog(@"操作失败:%@(%li)",[response msg], (long)[response msg]);
        }
    }
    
}


-(void)requestFailure:(NSURLSessionDataTask *)task withResponse:(EWGResponse *)response{
    
    NSString *message=[response msg];
#ifdef DEBUG
    message=[NSString stringWithFormat:@"%@(%li)",[response msg],(long)[response msg]];
#endif
    
     if (SHOW_HTTP_LOG) {
         NSLog(@"请求失败:%@", message);
     }
    
    [self hiddenProgress:self msg:message afterDeley:YES];
}



@end
