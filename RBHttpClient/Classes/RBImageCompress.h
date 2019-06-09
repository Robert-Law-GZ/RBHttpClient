//
//  SWTImageCompress.h
//  Pods
//
//  Created by Lo Robert on 2017/8/10.
//
//

#import <Foundation/Foundation.h>

@interface RBImageCompress : NSObject

+(NSData *)compressWithImage:(UIImage *)image compressTo:(NSUInteger)mb;
+(NSData *)compressWithImage:(UIImage *)image;

@end
