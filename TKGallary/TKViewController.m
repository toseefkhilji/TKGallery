//
//  ViewController.m
//  TKGallary Live images

//
//  Created by Toseefhusen on 18/12/13.
//  Copyright (c) 2013 Toseef Khilji. All rights reserved.
//

#import "TKViewController.h"
#import "TKDetailViewController.h"
#import "AsyncImageView.h"

static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    size.width *= height / size.height;
    size.height = height;
    return size;
}

@interface TKViewController ()
@property (strong, nonatomic)NSURL *url;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
- (void)placeImages;
- (void)setFramesToWebImageViews:(NSMutableArray *)imageViews toFitSize:(CGSize)frameSize;
- (CGSize)setFramesToImageViews:(NSArray *)imageViews toFitSize:(CGSize)frameSize;
- (void)deviceOrientationChange;
@end

@implementation TKViewController
@synthesize contentView;

- (id)initWithImages:(NSMutableArray *)images
{
    if (self = [super init]) {
        self.images = images;
        mode=mLoadStaticImages;
        self.title=@"TKGallery";
    }
    return self;
}
- (id)initWithUrls:(NSMutableArray *)ary
{
    if (self = [super init])
    {
        self.images=[NSMutableArray array];
        self.images=ary;
        mode=mLoadWebImages;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (mode==mLoadStaticImages)
        self.title=@"Static Images";
    else
        self.title=@"Web Images";

    [self.contentView setBackgroundColor:[UIColor grayColor]];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.contentView];
    self.activity.hidden=NO;
    self.contentView.alpha=0.2;
    
    [self placeImages];
    
    self.activity.hidden=YES;
    self.contentView.alpha=1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
        [self placeImages];
    
}

- (void)placeImages
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (mode==mLoadWebImages)
    {
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < self.images.count; i++)
        {
            float w =   arc4random_uniform(101) + 100;
            float h =   arc4random_uniform(201) + 100;
            CGSize cg=CGSizeMake(w, h);
            [imageViews addObject:[NSValue valueWithCGSize:cg]];
        }

        [self setFramesToWebImageViews:imageViews toFitSize:self.contentView.frame.size];
        for (int j=0; j<imageViews.count; j++)
        {
            NSValue *v=imageViews[j];
            
            AsyncImageView *a=[[AsyncImageView alloc]initWithFrame:[v CGRectValue]];
            [a setBackgroundColor:[UIColor whiteColor]];
            NSURL *u=[self.images objectAtIndex:j];
            [a loadImageFromURL:u];
            a.userInteractionEnabled=YES;
            a.tag=j;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethodAsync:)];
            [tap setNumberOfTouchesRequired:1];
            [tap setNumberOfTapsRequired:1];
            [a addGestureRecognizer:tap];
            [self.contentView addSubview:a];
        }
    
    }
    else
    {
        NSMutableArray *imageViews = [NSMutableArray array];
        for (UIImage *image in self.images) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageViews addObject:imageView];
        }
        
        CGSize newSize = [self setFramesToImageViews:imageViews toFitSize:self.contentView.frame.size];
        self.contentView.contentSize = newSize;
        int i=0;
        for (UIImageView *iimageView in imageViews)
        {
            iimageView.userInteractionEnabled=YES;
            iimageView.tag=i;
            i++;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod:)];
            [tap setNumberOfTouchesRequired:1];
            [tap setNumberOfTapsRequired:1];
            [iimageView addGestureRecognizer:tap];
            [self.contentView addSubview:iimageView];
        }
        
    }

}
- (void) myTapMethod:(UIGestureRecognizer *)sender
{
    
    TKDetailViewController *d=[[TKDetailViewController alloc]initWithImages:self.images WithNibName:@"TKDetailViewController" bundle:nil idx:(int)sender.view.tag andMode:mode];
    [self.navigationController pushViewController:d animated:YES];
}
- (void) myTapMethodAsync:(UIGestureRecognizer *)sender
{
    
    TKDetailViewController *d=[[TKDetailViewController alloc]initWithImages:[self.contentView  subviews] WithNibName:@"TKDetailViewController" bundle:nil idx:(int)sender.view.tag andMode:mode];
    [self.navigationController pushViewController:d animated:YES];
}
- (void)deviceOrientationChange {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(placeImages) object:nil];
    [self performSelector:@selector(placeImages) withObject:nil afterDelay:1];
}

#pragma mark

- (void)setFramesToWebImageViews:(NSMutableArray *)imageViews toFitSize:(CGSize)frameSize {
    /**
     Linear Partition
     */
    int N = (int)imageViews.count;
    CGRect newFrames[N];
    float ideal_height = MAX(frameSize.height, frameSize.width) /3.5;
    float seq[N];
    float total_width = 0;
    for (int i = 0; i < imageViews.count; i++) {
     //   UIImage *image = [[imageViews objectAtIndex:i] image];
        NSValue *v=imageViews[i];
        CGSize newSize = CGSizeResizeToHeight([v CGSizeValue], ideal_height);
        newFrames[i] = (CGRect) {{0, 0}, newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    /**
     Ranges & Resizes
     */
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    [imageViews removeAllObjects];
    for (int i = 0; i < N; i++)
    {
        CGRect cg=newFrames[i];
        [imageViews addObject:[NSValue valueWithCGRect:cg]];

    }
   self.contentView.contentSize =CGSizeMake(frameSize.width, heightOffset);
}
- (CGSize)setFramesToImageViews:(NSArray *)imageViews toFitSize:(CGSize)frameSize {
    /**
     Linear Partition
     */
    int N = (int)imageViews.count;
    CGRect newFrames[N];
    float ideal_height = MAX(frameSize.height, frameSize.width) /3.5;
    float seq[N];
    float total_width = 0;
    for (int i = 0; i < imageViews.count; i++) {
        UIImage *image = [[imageViews objectAtIndex:i] image];
        CGSize newSize = CGSizeResizeToHeight(image.size, ideal_height);
        newFrames[i] = (CGRect) {{0, 0}, newSize};
        seq[i] = newSize.width;
        total_width += seq[i];
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    float cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    /**
     Ranges & Resizes
     */
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    while (k1 >= 0) {
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    float heightOffset = cellDistance, widthOffset;
    float frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            rowWidth += newFrames[j].size.width;
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    for (int i = 0; i < N; i++) {
        UIImageView *imgView = imageViews[i];
        imgView.frame = newFrames[i];
        [self.contentView addSubview:imgView];
    }
    
    return CGSizeMake(frameSize.width, heightOffset);
}
@end
