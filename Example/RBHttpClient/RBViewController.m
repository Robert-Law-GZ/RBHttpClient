//
//  RBViewController.m
//  RBHttpClient
//
//  Created by Robert-Law-GZ on 06/09/2019.
//  Copyright (c) 2019 Robert-Law-GZ. All rights reserved.
//

#import "RBViewController.h"
#import <RBHttpClient-umbrella.h>
#import <RSAUtil.h>
#import "UIViewController+THZRequestClient.h"

@interface RBViewController ()

@end

@implementation RBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *timestamp=[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
//    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//    [dict setValue:timestamp forKey:@"request_time"];
//
//    NSString *ss=[RBRequestManager paramSortToString:dict];
//    NSString *sign=[RSAUtil encryptString:ss publicKey:PUBLIC_KEY];
//    [dict setValue:sign forKey:@"apisign"];
//
//    RBRequestManager *manager = [RBRequestManager manager];
//    [manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
    
    [self buildPOSTRequest:@"/mobile/unify" withParams:[NSDictionary dictionary]];
    
//    NSLog(@"--%@",sign);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestSuccess:(NSURLSessionDataTask *)task withResponse:(RBResponse *)response{
    NSLog(@"====%@",response.result);
}

@end
