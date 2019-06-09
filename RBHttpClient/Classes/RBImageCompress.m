//
//  SWTImageCompress.m
//  Pods
//
//  Created by Lo Robert on 2017/8/10.
//
//

#define k_compress_size_mb    4

#import "RBImageCompress.h"

@implementation RBImageCompress

+(NSData *)compressWithImage:(UIImage *)image compressTo:(NSUInteger)mb{
    NSData *data=[[NSData alloc] init];
    
    data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat count = 100;
    
    while (data.length > mb*1024*1024) {
        count--;
        data =  UIImageJPEGRepresentation(image, count / 100);
    }

    return data;
}

+(NSData *)compressWithImage:(UIImage *)image{
    return [RBImageCompress compressWithImage:image compressTo:k_compress_size_mb];
}

@end
