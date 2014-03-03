//
//  AsyncImageView.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;

@implementation AsyncImageView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)dealloc {
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [self.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    self.layer.borderWidth=2.0;
    if (cachedImage != nil)
    {
        if ([[self subviews] count] > 0)
        {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:cachedImage] autorelease];
        [imageView setTag:203];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        //        [imageView setBackgroundColor:[UIColor grayColor]];
        //        [imageView.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
        //        [imageView.layer setBorderWidth:3.0];
        //
        if([self.delegate respondsToSelector:@selector(getSyncImage:)])    {
            [self.delegate getSyncImage:cachedImage];
        }
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        return;
    }
    
#define SPINNY_TAG 5555
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
    spinny.center = self.center;
    [spinny startAnimating];
    [self addSubview:spinny];
    [spinny release];
    
    spinny.hidden=TRUE;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    [connection release];
    connection = nil;
    [self setBackgroundColor:[UIColor lightGrayColor]];
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    
    UIImageView *imageView = [[[UIImageView alloc]
                               initWithImage:image] autorelease];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageView setTag:203];
    //    imageView.backgroundColor=[UIColor clearColor];
    //    [imageView.layer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    //    [imageView.layer setBorderWidth:3.0];
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
    if([self.delegate respondsToSelector:@selector(getSyncImage:)])    {
        [self.delegate getSyncImage:image];
    }
    [data release];
    data = nil;
}

@end
