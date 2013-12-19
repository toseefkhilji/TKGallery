//
//  Detail.m
//  NVImageGridSample
//
//  Created by Toseefhusen on 18/12/13.
//  Copyright (c) 2013 nkanaev. All rights reserved.
//

#import "Detail.h"
#import "AsyncImageView.h"
@interface Detail ()

@property(nonatomic,strong)IBOutlet UIImageView *imageView;
@property(nonatomic,strong)IBOutlet UIScrollView *scroll;

@end

@implementation Detail


- (id)initWithImages:(NSArray *)images WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil idx:(int)indx andMode:(int)modes
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        index=indx;
        mode=modes;
        self.images = images;
        self.title =[NSString stringWithFormat:@"%d of %d",index+1,(int)self.images.count+1];
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (mode==mLoadStaticImages)
    self.imageView.image=self.images[index];
    else
    {
        AsyncImageView *a=self.images[index];
        UIImageView *i=(UIImageView*)[a viewWithTag:203];
        self.imageView.image=i.image;
        
    }
    [self.view layoutIfNeeded];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(imageShare:)];
    
      //  self.navigationController.navigationBar.barTintColor=[UIColor brownColor];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
}
-(void)deviceOrientationChange
{
    
}

-(IBAction)gotoNext:(id)sender
{
    if (index<[self.images count]-1)
    {
        index++;
        self.title =[NSString stringWithFormat:@"%d of %d",index+1,(int)self.images.count+1];
       // self.imageView.image=self.images[index];
        if (mode==mLoadStaticImages)
            self.imageView.image=self.images[index];
        else
        {
            AsyncImageView *a=self.images[index];
            UIImageView *i=(UIImageView*)[a viewWithTag:203];
            self.imageView.image=i.image;
            
        }
        [self slideNext:self.scroll];
    }    
}
-(IBAction)gotoPrev:(id)sender
{
    
    if (index>0)
    {
        index--;
        self.title =[NSString stringWithFormat:@"%d of %d",index+1,(int)self.images.count+1];
       // self.imageView.image=self.images[index];
        if (mode==mLoadStaticImages)
            self.imageView.image=self.images[index];
        else
        {
            AsyncImageView *a=self.images[index];
            UIImageView *i=(UIImageView*)[a viewWithTag:203];
            self.imageView.image=i.image;
            
        }
        [self slidePrev:self.scroll];
    }
    
}
-(IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

-(void)slideNext:(UIView *)view
{
    
    
    CGRect or=view.frame;
    
    CGRect basketTopFrame = view.frame;
    basketTopFrame.origin.x =  basketTopFrame.size.width;
    view.frame = basketTopFrame;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCurlUp
                     animations:^{
                         view.frame=or;
                         // basketBottom.frame = basketBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}


-(void)slidePrev:(UIView *)view
{
    CGRect or=view.frame;
    
    CGRect basketTopFrame = view.frame;
    basketTopFrame.origin.x = -( basketTopFrame.size.width);
    view.frame = basketTopFrame;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame=or;
                         // basketBottom.frame = basketBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

-(IBAction)imageShare:(id)sender
{
    UIImage *imageToShare = self.imageView.image;
    NSArray *activityItems = @[ imageToShare];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                   initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes=@[UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
