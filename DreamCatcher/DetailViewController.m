//
//  DetailViewController.m
//  DreamCatcher
//
//  Created by Matt Deuschle on 12/31/15.
//  Copyright © 2015 Matt Deuschle. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set title of vc to title of dream
    self.title = self.titleString;

    // set description
    self.textView.text = self.descriptionString;
}



@end
