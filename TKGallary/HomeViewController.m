//
//  HomeViewController.m
//  TKGallery
//
//  Created by Toseefhusen on 19/12/13.
//  Copyright (c) 2013 Toseef Khilji. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"TK Gallery";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)staticImgs:(id)sender
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 15; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%02i.jpg", i];
        [images addObject:[UIImage imageNamed:fileName]];
    }
    for (int i = 0; i <= 15; i++) {
        [images exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(15)];
    }

    UrlViewController *galleryCtrl=[[UrlViewController alloc]initWithImages:images];
    [self.navigationController pushViewController:galleryCtrl animated:YES];
    
}

-(IBAction)dynImages:(id)sender
{
    
    UrlViewController *galleryCtrl=[[UrlViewController alloc]initWithUrls:[self loadImagesUrl:[NSURL URLWithString:@"http://itunes.apple.com/search?term=bond&country=us&entity=movie"]]];
    [self.navigationController pushViewController:galleryCtrl animated:YES];


}
-(NSMutableArray *)loadImagesUrl:(NSURL*)url
{
    
    NSError *error;
    NSMutableArray *ary=[NSMutableArray array];
    NSURLRequest *rq=[NSURLRequest requestWithURL: url];
    NSData *response = [NSURLConnection sendSynchronousRequest:rq returningResponse:nil error:&error];
    NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:response  options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dicts in [dict objectForKey:@"results"])
    {
        [ary addObject:[NSURL URLWithString:[dicts objectForKey:@"artworkUrl100"]]];
    }
    
    //NSLog(@"log:%@",self.images);
    
    
    return ary;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
