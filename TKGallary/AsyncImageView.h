//
//  AsyncImageView.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


//
// Code heavily lifted from here:
// http://www.markj.net/iphone-asynchronous-table-image/
//

#import <UIKit/UIKit.h>

@protocol AsyncImageViewDelegate <NSObject>

@optional
-(void)getSyncImage:(UIImage*)image;

@end

@interface AsyncImageView : UIView {
    NSURLConnection *connection;
    NSMutableData *data;
    NSString *urlString; // key for image cache dictionary
    id <AsyncImageViewDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
-(void)loadImageFromURL:(NSURL*)url;
@end
