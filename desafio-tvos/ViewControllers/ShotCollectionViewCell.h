//
//  ShotCollectionViewCell.h
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/25/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Models.h"

@interface ShotCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ShotModel *shotObject;

+ (NSString *) cellIdentifier;

@end
