//
//  HomeViewController.m
//  TKGallary
//
//  Created by Toseef Khilji (toseefkhilji@gmail.com) on 18/12/13.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

    TKViewController *galleryCtrl=[[TKViewController alloc]initWithImages:images];
    [self.navigationController pushViewController:galleryCtrl animated:YES];
    
}

-(IBAction)dynImages:(id)sender
{
    
    TKViewController *galleryCtrl=[[TKViewController alloc]initWithUrls:[self loadImagesUrl:[NSURL URLWithString:@"http://itunes.apple.com/search?term=bob&country=us&entity=movie"]]];
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
