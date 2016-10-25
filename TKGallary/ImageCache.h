//
//  ImageCache.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageCacheObject;

@interface ImageCache : NSObject {
    NSUInteger totalSize;  // total number of bytes
    NSUInteger maxSize;    // maximum capacity
    NSMutableDictionary *myDictionary;
    
    NSDate *oldestTime;
    NSString *oldestKey;
}

@property (nonatomic, readonly) NSUInteger totalSize;

-(id)initWithMaxSize:(NSUInteger) max;
-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key;
-(UIImage*)imageForKey:(NSString*)key;

@end
