//
//  HomeViewController.m
//  Portfolio
//
//  Created by Jatin Pandey on 10/4/15.
//  Copyright © 2015 Jatin Pandey. All rights reserved.
//

#import "HomeViewController.h"
#import "SocialViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

NSDictionary *socialDict;
NSArray *pics;
static int picIndex;

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    socialDict = @{@"linkedIn": @"http://www.linkedin.com/in/jatinpandey", @"github": @"http://www.github.com/jatinpandey", @"twitter": @"http://www.twitter.com/jatinpandey"};
    pics = @[@"cheesy", @"quora", @"img1", @"visionary"];
    picIndex = 0;
    NSURL *picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.jatinpandey.com/img/%@.jpg", pics[picIndex]]];

    [self.profileImageView setImageWithURL:picUrl placeholderImage:[UIImage imageNamed:@"paan"]];
    CALayer *layer = [self.profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.profileImageView.frame.size.width / 2];
    
    UIColor *tealColor = [HomeViewController colorFromHexString:@"#e3f6fe"];
    [self.view setBackgroundColor:tealColor];

    NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)changePic {
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.profileImageView.alpha = 0;
                     }
                     completion:nil];
    picIndex += 1;
    NSURL *picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.jatinpandey.com/img/%@.jpg", pics[picIndex % pics.count]]];
    [self.profileImageView setImageWithURL:picUrl];
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.profileImageView.alpha = 1;
                     }
                     completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPushLinkedIn:(id)sender {
    [self performSegueWithIdentifier:@"pushSocialSegue" sender:@"linkedIn"];
}

- (IBAction)onPushGithub:(id)sender {
    [self performSegueWithIdentifier:@"pushSocialSegue" sender:@"github"];
}

- (IBAction)onPushTwitter:(id)sender {
    [self performSegueWithIdentifier:@"pushSocialSegue" sender:@"twitter"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SocialViewController *svc = [segue destinationViewController];
    NSLog(@"Sender: %@", sender);
    svc.socialUrl = [socialDict objectForKey:sender];    
}

@end
