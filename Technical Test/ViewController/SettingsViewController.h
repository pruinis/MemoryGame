//
//  SettingsViewController.h
//  Technical Test
//
//  Created by Anton Morozov on 23.12.2019.
//  Copyright © 2019 GPG. All rights reserved.
//

@import UIKit;
@class GameDirector;

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *sizeTextField;
@property (weak, nonatomic) IBOutlet UISwitch *undoSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, weak, nullable) GameDirector *director;

@end

NS_ASSUME_NONNULL_END
