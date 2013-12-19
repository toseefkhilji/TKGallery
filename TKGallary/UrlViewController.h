//
//  UrlViewController.h
//  TKGallery
//
//  Created by Toseefhusen on 19/12/13.
//  Copyright (c) 2013 Toseef Khilji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlViewController : UIViewController
{
    UIScrollView *contentView;
    enum myViewMode mode;
    NSMutableArray *arrayAsync;

}

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong)IBOutlet UIScrollView *contentView;
- (id)initWithUrls:(NSMutableArray *)ary;
- (id)initWithImages:(NSMutableArray *)images;


@end
