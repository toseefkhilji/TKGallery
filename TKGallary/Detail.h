//
//  Detail.h
//  NVImageGridSample
//
//  Created by Toseefhusen on 18/12/13.
//  Copyright (c) 2013 nkanaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detail : UIViewController
{
    int index;
    enum myViewMode mode;

}
- (id)initWithImages:(NSArray *)images WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil idx:(int)indx andMode:(int)modes;

@property (nonatomic, strong) NSArray *images;

@end
