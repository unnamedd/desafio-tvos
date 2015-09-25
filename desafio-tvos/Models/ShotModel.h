//
//  ShotModel.h
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/23/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface PlayerModel : JSONModel

@property (strong, nonatomic) NSNumber *uuid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;
@property (assign, nonatomic) int followers_count;
@property (assign, nonatomic) int draftees_count;
@property (assign, nonatomic) int likes_count;
@property (assign, nonatomic) int likes_received_count;
@property (assign, nonatomic) int comments_count;
@property (assign, nonatomic) int comments_received_count;
@property (assign, nonatomic) int rebounds_count;
@property (assign, nonatomic) int rebounds_received_count;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *twitter_screen_name;
@property (strong, nonatomic) NSString *website_url;
@property (strong, nonatomic) NSNumber *drafted_by_player_id;
@property (assign, nonatomic) int shots_count;
@property (assign, nonatomic) int following_count;
@property (strong, nonatomic) NSDate *created_at;

@end

@interface ShotModel : JSONModel

@property (strong, nonatomic) NSNumber *uuid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptions;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int likes_count;
@property (assign, nonatomic) int comments_count;
@property (assign, nonatomic) int rebounds_count;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *short_url;
@property (assign, nonatomic) int views_count;
@property (strong, nonatomic) NSString *rebound_source_id;
@property (strong, nonatomic) NSString *image_url;
@property (strong, nonatomic) NSString *image_teaser_url;
@property (strong, nonatomic) NSString *image_400_url;
@property (strong, nonatomic) PlayerModel *player;
@property (strong, nonatomic) NSDate *created_at;

@end
