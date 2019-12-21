//
//  SettingsViewController.m
//  Technical Test
//
//  Created by Anton Morozov on 23.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameDirector.h"
#import "GenericPopUp.h"

@interface SettingsViewController () <UIPickerViewDelegate, UIPickerViewDataSource, GenericPopUpDelegate>

@property (nonatomic, strong) NSMutableArray *boardSizes;
@property (nonatomic, strong) NSNumber *selectedBoardSize;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBoardSizes];
    self.undoSwitch.on = !self.director.undoButtonIsHidden;
    self.selectedBoardSize = @(self.director.pairNumber);    
    self.sizeTextField.text = [self boardSizeString:self.selectedBoardSize];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    pickerView.showsSelectionIndicator = YES;
    self.sizeTextField.inputView = pickerView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
}

-(void)setupBoardSizes {
    self.boardSizes = [NSMutableArray array];
    int min = self.director.boardSizeMin;
    int max = self.director.boardSizeMax;
    for (int i = min; i <= max; i++) {
        [self.boardSizes addObject: @(i)];
    }
}

-(NSString *)boardSizeString:(NSNumber *)boardSize {
    return [NSString stringWithFormat:@"%@ * %@", boardSize, boardSize];
}

-(void)confirmChangesPopup {
    NSArray *confirm = [NSArray arrayWithObjects:@"Confirm", [UIColor redColor], nil];
    GenericPopUp *popup = [[GenericPopUp alloc] initWithTitle:@"Confirm changes?"
                                                      message:@"Game will resetting"
                                                    accessory:nil
                                                  withButtons: @[confirm]
                                                         size:2
                                                  andDelegate:self
                                                   needResize:NO
                                                   andCanHide:YES];
    [popup showWithDelay:0 and:0.2 inController:self];
}

// MARK: - Button actions

- (IBAction)saveAction:(id)sender {
    [self.view endEditing:YES];
    [self confirmChangesPopup];
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView { 
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.boardSizes.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSNumber *number = self.boardSizes[row];
    return [self boardSizeString:number];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSNumber *number = self.boardSizes[row];
    self.sizeTextField.text = [self boardSizeString:number];
    self.selectedBoardSize = number;
}

// MARK: - GenericPopUpDelegate

-(void)genericPopUp:(GenericPopUp *)gPopUp touchedButtonAtIndex:(NSInteger)btnIndex {
    if (btnIndex == 0) {
        self.director.undoButtonIsHidden = !self.undoSwitch.on;
        [self.director setBoardSize:self.selectedBoardSize.intValue];
        [self.director stop];        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
