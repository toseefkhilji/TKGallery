TKGallery
=========

TKGallery is a simple iOS photo browser with dynamic grid view of images, 
TKGallery can display one or more images by providing either UIImage objects. 
Photos can be zoomed and panned.  The browser can also be used to allow the user to share image to social networking sites from main detail image view.


![logo](http://i.imgur.com/UYJj1y7.png)

## Requirements ##

1) Xcode 5 and above versions.

2) ARC


## Usage ##

1) Import `TKViewController.h` 

2) Create Array of Images and alloc TKViewController 
      
      NSMutableArray *images = [NSMutableArray array];
     [images addObject:[UIImage imageNamed:@"01.png"]];
     [images addObject:[UIImage imageNamed:@"02.png"]];

    TKViewController *galleryCtrl=[[TKViewController alloc]initWithImages:images];
    
    [self.navigationController pushViewController:galleryCtrl animated:YES];



License
-------

TKGallery is available under the MIT license. See the LICENSE file for more info.
