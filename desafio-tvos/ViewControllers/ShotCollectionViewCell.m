//
//  ShotCollectionViewCell.m
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/25/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "ShotCollectionViewCell.h"

#import "Services.h"

@interface ShotCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *shotImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;

@end

@implementation ShotCollectionViewCell

+ (NSString *) cellIdentifier {
    return @"shotCellIdentifier";
}

- (void)setShotObject:(ShotModel *)shotObject {
    
    _shotObject = shotObject;
    
    if (shotObject) {
        
        // Shot image
        if (shotObject.images.normal) {
            [self.activityIndicator startAnimating];
            
            [[BaseService sharedInstance] downloadImageWithURL: shotObject.images.normal
                                                      complete:^(UIImage *image, NSError *error) {
                                                          if (!error) {
                                                              [self.shotImageView setImage: image];
                                                              [self.activityIndicator stopAnimating];
                                                          }
                                                      }];
        }
        
        // Shot activities
        NSMutableString *activityMutableString = [NSMutableString new];
        if (shotObject.views_count > 0)
            [activityMutableString appendFormat: @" <V> %li", (long)shotObject.views_count];
        
        if (shotObject.comments_count > 0)
            [activityMutableString appendFormat: @" <C> %li", (long)shotObject.comments_count];
        
        if (shotObject.likes_count > 0)
            [activityMutableString appendFormat: @" <L> %li", (long)shotObject.likes_count];
        
        if ([activityMutableString length] > 0)
            self.activityLabel.text = activityMutableString;
        
        
        if (shotObject.user.name) {
            self.teamLabel.text = shotObject.user.name;
        }
        
        // Player avatar image
        if (shotObject.user.avatar_url) {
            [[BaseService sharedInstance] downloadImageWithURL: shotObject.user.avatar_url complete:^(UIImage *image, NSError *error) {
                if (!error) {
                    [self.teamImageView setImage: image];
                    self.teamImageView.layer.cornerRadius = self.teamImageView.frame.size.height / 2;
                }
                else
                    self.teamImageView.hidden = YES;
            }];
        }
    }
}

@end
