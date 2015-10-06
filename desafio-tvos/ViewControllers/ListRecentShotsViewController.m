//
//  ListRecentShotsViewController.m
//  desafio-tvos
//
//  Created by Eduardo Rangel on 10/5/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "ListRecentShotsViewController.h"
#import "Services.h"
#import "ShotCollectionViewCell.h"
#import "ShotViewController.h"

@interface ListRecentShotsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *shots;
@property (nonatomic, strong) ShotModel *shot;

@end



@implementation ListRecentShotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *shotCollectionViewCellNib = [UINib nibWithNibName:@"ShotCollectionViewCell" bundle:nil];
    
    [self.collectionView registerNib:shotCollectionViewCellNib forCellWithReuseIdentifier:[ShotCollectionViewCell cellIdentifier]];
    
    [self requestRecentShots];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShotSegue"]) {
        ShotViewController *viewController = [segue destinationViewController];
        viewController.shot = self.shot;
    }
}



#pragma mark - Requests

- (void)requestRecentShots {
    [[ShotsService sharedInstance] listRecentWithPage:0 complete:^(NSArray *items, NSInteger totalPages, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.shots = [NSArray arrayWithArray: items];
                [self.collectionView reloadData];
            });
        }
    }];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shots count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ShotCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    ShotModel *item = [self.shots objectAtIndex:indexPath.item];
    [cell setShotObject:item];
    
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.shot = [self.shots objectAtIndex: indexPath.item];
    
    NSLog(@"Shot Mode: %@", self.shot);
}



@end