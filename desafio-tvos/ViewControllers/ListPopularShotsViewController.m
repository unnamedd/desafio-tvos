//
//  ListPopularShotsViewController.m
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/23/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "ListPopularShotsViewController.h"

// Services
#import "Services.h"

// Custom View
#import "ShotCollectionViewCell.h"

@interface ListPopularShotsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *shotsSource;

@end

@implementation ListPopularShotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Custom Collection View Cell
    UINib *shotCollectionViewCellNib = [UINib nibWithNibName: @"ShotCollectionViewCell" bundle: nil];
    [self.collectionView registerNib: shotCollectionViewCellNib
          forCellWithReuseIdentifier: [ShotCollectionViewCell cellIdentifier]];
    
    [self requestPopularShots];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests

- (void) requestPopularShots {
    [[ShotsService sharedInstance] listPopularWithPage:0 complete:^(NSArray *items, NSInteger totalPages, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.shotsSource = [NSArray arrayWithArray: items];
                [self.collectionView reloadData];
            });
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView Data Source

- (NSInteger) collectionView:(UICollectionView *) collectionView numberOfItemsInSection:(NSInteger) section {
    return [self.shotsSource count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *) collectionView cellForItemAtIndexPath:(NSIndexPath *) indexPath {
    ShotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: [ShotCollectionViewCell cellIdentifier]
                                                                             forIndexPath: indexPath];
    
    ShotModel *item = [self.shotsSource objectAtIndex: indexPath.item];
    [cell setShotObject: item];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShotModel *shotSelected = [self.shotsSource objectAtIndex: indexPath.item];
    NSLog(@"Shot Mode; %@", shotSelected);
}

@end
