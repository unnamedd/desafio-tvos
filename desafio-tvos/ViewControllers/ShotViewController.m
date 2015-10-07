//
//  ShotViewController.m
//  desafio-tvos
//
//  Created by Eduardo Rangel on 10/5/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "ShotViewController.h"

#import "Services.h"



@interface ShotViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end



@implementation ShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) configureData {

    self.nameLabel.text = self.shotObject.title;
    self.playerNameLabel.text = self.shotObject.user.name;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate: self.shotObject.created_at
                                                          dateStyle: NSDateFormatterShortStyle
                                                          timeStyle: NSDateFormatterFullStyle];
    self.dateLabel.text = dateString;
    
    // Shot image
    if (self.shotObject.images.normal) {
        [self.activityIndicator startAnimating];
        
        [[BaseService sharedInstance] downloadImageWithURL: self.shotObject.images.normal
                                                  complete:^(UIImage *image, NSError *error) {
                                                      if (!error) {
                                                          [self.imageView setImage: image];
                                                          [self.activityIndicator stopAnimating];
                                                      }
                                                  }];
    }
    
    // Shot activities
    if (self.shotObject.views_count > 0)
        self.viewsLabel.text = [NSString stringWithFormat: @" Views: %li", (long)self.shotObject.views_count];
    
    if (self.shotObject.comments_count > 0)
        self.commentsLabel.text = [NSString stringWithFormat: @" Comments: %li", (long)self.shotObject.comments_count];
    
    if (self.shotObject.likes_count > 0)
        self.likesLabel.text = [NSString stringWithFormat: @" Likes: %li", (long)self.shotObject.likes_count];
    
    if (self.shotObject.user.name) {
        self.playerNameLabel.text = self.shotObject.user.name;
    }
    
    if (self.shotObject.description)
        self.descriptionLabel.text = self.shotObject.descriptions;
    
    // Player avatar image
    if (self.shotObject.user.avatar_url) {
        [[BaseService sharedInstance] downloadImageWithURL: self.shotObject.user.avatar_url complete:^(UIImage *image, NSError *error) {
            if (!error) {
                [self.playerImageView setImage: image];
                self.playerImageView.layer.cornerRadius = self.playerImageView.frame.size.height / 2;
            }
            else
                self.playerImageView.hidden = YES;
        }];
    }
    
}


@end