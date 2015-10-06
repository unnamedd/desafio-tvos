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

#import "Models.h"

#import "ShotViewController.h"

@interface ListPopularShotsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *shotsSource;
@property (strong, nonatomic) ShotModel *shot;

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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"popularShotSegue"]) {
        ShotViewController *viewController = [segue destinationViewController];
        viewController.shotObject = self.shot;
    }
}


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
    self.shot = [self.shotsSource objectAtIndex: indexPath.item];
    [self performSegueWithIdentifier: @"popularShotSegue"
                              sender: nil];
}

@end
