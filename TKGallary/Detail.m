//
//  Detail.m
//  NVImageGridSample
//
//  Created by Toseefhusen on 18/12/13.
//  Copyright (c) 2013 nkanaev. All rights reserved.
//

#import "Detail.h"
#import "AsyncImageView.h"
#import "MyScrollView.h"
@interface Detail ()

@property(nonatomic,strong)IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MyScrollView *myScroll;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;

@end

@implementation Detail
{
    BOOL _oldBounces;

}

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
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(imageShare:)];
    
      //  self.navigationController.navigationBar.barTintColor=[UIColor brownColor];

       //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    if (mode==mLoadStaticImages)
        gImage=self.images[index];
    else
    {
        AsyncImageView *a=self.images[index];
        UIImageView *i=(UIImageView*)[a viewWithTag:203];
        gImage=i.image;
        self.imageView.image=i.image;
        
    }
    
    [self loadView:gImage];
}
-(void)loadView:(UIImage *)image {
  //  UIScrollView* sv = [[MyScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
   
 //   self.view=sv;
  //  sv.backgroundColor = [UIColor blackColor];
    
   // UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bird.jpg"]];
    self.myToolbar.hidden=FALSE;

    [self.myScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.tag = 999;
    [self.myScroll addSubview:iv];
    self.myScroll.contentSize = iv.bounds.size;
    
    UITapGestureRecognizer* t = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tapped:)];
    t.numberOfTapsRequired = 2;
    [iv addGestureRecognizer:t];
    iv.userInteractionEnabled = YES;
    
    // feel free to play with these numbers
    self.myScroll.maximumZoomScale = 3;
    self.myScroll.minimumZoomScale = 0.5;
    self.myScroll.delegate = self;
   // CGPoint pt = CGPointMake((iv.bounds.size.width - self.myScroll.bounds.size.width)/2.0,0);
   // [self.myScroll setContentOffset:pt animated:NO];
    self.myScroll.bouncesZoom = NO; // try it with YES, but I like this better
    // [ self.myScroll setZoomScale:1 animated:YES];
    
}

- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView
                           withView:(UIView *)view {
    self->_oldBounces = scrollView.bounces;
    scrollView.bounces = NO; // again, you can comment this out, but I like the result better
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView
                        withView:(UIView *)view atScale:(float)scale {
    scrollView.bounces = self->_oldBounces;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:999];
}

// the picture is also zoomable by double-tapping

- (void) tapped: (UIGestureRecognizer*) tap {
    UIView* v = tap.view;
    
    UIScrollView* sv = (UIScrollView*)v.superview;
    if (sv.zoomScale < 1) {
        [sv setZoomScale:1 animated:YES];
        CGPoint pt = CGPointMake((v.bounds.size.width - sv.bounds.size.width)/2.0,0);
        [sv setContentOffset:pt animated:NO];
    }
    else if (sv.zoomScale < sv.maximumZoomScale){
        [sv setZoomScale:sv.maximumZoomScale animated:YES];
        CGRect frm=sv.frame;
        frm.size.height+=self.myToolbar.frame.size.height;
        sv.frame=frm;
       self.myToolbar.hidden=TRUE;
    }
    else
    {   [sv setZoomScale:sv.minimumZoomScale animated:YES];
        self.myToolbar.hidden=FALSE;
        CGRect frm=sv.frame;
        frm.size.height-=self.myToolbar.frame.size.height;
        sv.frame=frm;
    }
    
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
            gImage=self.images[index];
        else
        {
            AsyncImageView *a=self.images[index];
            UIImageView *i=(UIImageView*)[a viewWithTag:203];
            gImage=i.image;
            self.imageView.image=i.image;
            
        }
        [self loadView:gImage];
        [self slideNext:self.myScroll];
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
            gImage=self.images[index];
        else
        {
            AsyncImageView *a=self.images[index];
            UIImageView *i=(UIImageView*)[a viewWithTag:203];
            gImage=i.image;
            self.imageView.image=i.image;
            
        }
        
        [self loadView:gImage];
        [self slidePrev:self.myScroll];
    }
    
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
    UIImage *imageToShare = ((UIImageView*)[self.myScroll viewWithTag:999]).image;
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
