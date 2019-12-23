//
//  ViewController.m
//  Technical Test
//
//  Created by Jeremy Mercier on 21/05/2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "ViewController.h"
#import "GameDirector.h"
#import "GenericPopUp.h"
#import "CardCollectionViewCell.h"

NSString *const showSettingsSegue = @"showSettingsSegue";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GenericPopUpDelegate>

@property (nonatomic, strong) GameDirector *director;

@property (nonatomic, assign) NSUInteger layoutSpacing;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.director = [GameDirector new];

    self.collectionView.userInteractionEnabled = NO;
    self.undoButton.hidden = self.director.undoButtonIsHidden;
    self.layoutSpacing = 10;
    [self setupCollectionView];
    
    [self startNewGameHandler];
    [self winGameHandler];
    [self stopGameHandler];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateHeightConstraint];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.undoButton.hidden = self.director.undoButtonIsHidden;
    
    if (self.director) {
        [self.director resume];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.director pause];
}

-(void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = self.layoutSpacing;
    layout.minimumLineSpacing = self.layoutSpacing;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView reloadData];
}

-(void)updateHeightConstraint {
    CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    self.heightConstraint.constant = height;
    [self.view layoutIfNeeded];
}

-(void)restartGame {
    [self.director pause];
    NSArray *yes = [NSArray arrayWithObjects:@"Yes", [UIColor whiteColor], nil];
    NSArray *no = [NSArray arrayWithObjects:@"No", [UIColor redColor], nil];
    GenericPopUp *popup = [[GenericPopUp alloc] initWithTitle:@"Start game"
                                                      message:@"Are you sure?"
                                                    accessory:nil
                                                  withButtons: @[yes, no]
                                                         size:2
                                                  andDelegate:self
                                                   needResize:NO
                                                   andCanHide:NO];
    [popup showWithDelay:0 and:0.2 inController:self];
}

-(void)winGameHandler {
    __weak ViewController *weakSelf = self;    
    self.director.gameFinishedHandler = ^(NSTimeInterval time) {
        if (!weakSelf) { return; }
        [weakSelf stopTimer];
        NSString *scoreString = [weakSelf playTimeString:time];
        GenericPopUp *popup = [[GenericPopUp alloc] initWithTitle:@"You win!"
                                                          message:[NSString stringWithFormat:@"Score: %@", scoreString]
                                                        accessory:nil
                                                      withButtons: nil
                                                             size:1
                                                      andDelegate:weakSelf
                                                       needResize:NO
                                                       andCanHide:YES];
        [popup showWithDelay:0 and:0.2 inController:weakSelf];
    };
}

-(void)startNewGameHandler {
    __weak ViewController *weakSelf = self;
    self.director.startGameHandler = ^{
        if (!weakSelf) { return; }
        [weakSelf.collectionView reloadData];
        weakSelf.collectionView.userInteractionEnabled = YES;
        [weakSelf startTimer];
    };
}

-(void)stopGameHandler {
    __weak ViewController *weakSelf = self;
    self.director.stopGameHandler = ^{
        if (!weakSelf) { return; }
        [weakSelf stopTimer];
        [weakSelf updateTimer];
        weakSelf.collectionView.userInteractionEnabled = NO;
        [weakSelf.collectionView reloadData];
    };
}

// MARK: - Timer

-(void)startTimer {
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(updateTimer)
                                              userInfo:nil
                                               repeats:YES];
}

-(void)updateTimer {
    NSTimeInterval timeInterval = self.director.playingTime;
    [self.timerLabel setText:[self playTimeString:timeInterval]];
}

-(void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

-(NSString*)playTimeString:(NSTimeInterval)timeInterval {
    int min = timeInterval / 60;
    int sec = (int)timeInterval % 60;
    return [NSString stringWithFormat:@"%01d:%02d",min,sec];
}

// MARK: - Button actions

- (IBAction)startGameAction:(id)sender {
    [self restartGame];
}

- (IBAction)restartAction:(id)sender {
    [self restartGame];
}

- (IBAction)undoAction:(id)sender {    
    [self.director undoLastStep];
}

// MARK: - GenericPopUpDelegate

-(void)genericPopUp:(GenericPopUp *)gPopUp touchedButtonAtIndex:(NSInteger)btnIndex {
    if (btnIndex == 0) {
        [self.director startNewGame];
    }
    else {
        [self.director resume];
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellId";
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    CardModel *model = self.director.cards[indexPath.row];
    [cell updateWithModel:model];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.director.cards.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.director cardWasTapped:cell.model];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
    CGFloat widthAvailbleForAllItems =  (collectionView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right);
    CGFloat itemWidth = widthAvailbleForAllItems / self.director.pairNumber - flowLayout.minimumInteritemSpacing;
    return CGSizeMake(itemWidth, itemWidth);
}

// MARK: - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:showSettingsSegue]) {
        ViewController *vc = [segue destinationViewController];
        vc.director = self.director;
    }    
}

@end

