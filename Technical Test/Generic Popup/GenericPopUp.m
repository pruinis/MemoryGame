#import "GenericPopUp.h"
#import "GlobalFunctions.h"

#define DEFAULT_BLACK_COLOR ([UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0])
#define TITLE_FNT_SIZE  15.0
#define MSG_FNT_SIZE    11.0
#define BTN_Y_FNT_SIZE  16.0
#define BTN_N_FNT_SIZE  13.0
#define MSG_FRAME_W_RATIO 80.0/100.0
#define TITLE_FRAME_W_RATIO 80.0/100.0

@implementation GenericPopUp {
    NSInteger CustomContentType;
}


- (id)initWithTitle:(NSString *)title message:(NSString *)msg accessory:(NSString *)acc withButtons:(NSArray *)buttons size:(CGFloat)size andDelegate:(id)delegate needResize:(BOOL)val andCustomContent:(NSInteger) customContentType andCanHide:(BOOL)canHide {
    self = [super init];
    if (self) {
        
        CustomContentType = customContentType;
        _delegate = delegate;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        if ((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && width < height) || (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) && width > height)) {
            CGFloat tmp = width;
            
            width = height;
            height = tmp;
        }
        _needResize = val;
        [self setFrame:CGRectMake(0, 0, width, height)];
        bgAlpha = [[UIView alloc] initWithFrame:CGRectMake(-self.frame.size.width, -self.frame.size.height, 3*self.frame.size.width, 3*self.frame.size.height)];
        [bgAlpha setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
        [bgAlpha setUserInteractionEnabled:YES];
        [self addSubview:bgAlpha];
        
        if (canHide) {
            UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            [bgAlpha addGestureRecognizer:tapGesture];
        }
        
        [self initWindowFor:size];
        [self initTitleAndIconFor:title withW:width andH:height];
        [self initMessageFor:msg];
        [self initButtonsFor:buttons];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)msg accessory:(NSString *)acc withButtons:(NSArray *)buttons size:(CGFloat)size andDelegate:(id)delegate needResize:(BOOL)val andCanHide:(BOOL)canHide {
    self = [super init];
    if (self) {
        CustomContentType = customTypeNone;
        _delegate = delegate;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        if ((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && width < height) || (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) && width > height)) {
            CGFloat tmp = width;
            
            width = height;
            height = tmp;
        }
        _needResize = val;
        [self setFrame:CGRectMake(0, 0, width, height)];
        bgAlpha = [[UIView alloc] initWithFrame:CGRectMake(-self.frame.size.width, -self.frame.size.height, 3*self.frame.size.width, 3*self.frame.size.height)];
        [bgAlpha setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
        [bgAlpha setUserInteractionEnabled:YES];
        [self addSubview:bgAlpha];
        
        if (canHide) {
            UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
            [bgAlpha addGestureRecognizer:tapGesture];
        }
        //[self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
        [self initWindowFor:size];
        [self initTitleAndIconFor:title withW:width andH:height];
        [self initMessageFor:msg];
        [self initButtonsFor:buttons ];
    }
    return self;
}

- (void) showWithDelay:(NSTimeInterval)delay and:(NSTimeInterval)duration inController:(UIViewController *)ctrl{
    [self setAlpha:0];
    view.transform = CGAffineTransformMakeScale(1.15, 1.15);
    [ctrl.view addSubview:self];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setAlpha:1];
        self->view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

- (void)hide {
    if ([_delegate respondsToSelector:@selector(genericPopUpWillHide:)]) {
        [_delegate genericPopUpWillHide:self];
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
        self->view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)initWindowFor:(CGFloat)size {
    UIImage *bgImg = [UIImage imageNamed:@"generic_popup"];
    UIImage *rightSizeImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(bgImg.size.height * 15 / 100,
                                                                                bgImg.size.width * 15 / 100,
                                                                                bgImg.size.height * 15 / 100,
                                                                                bgImg.size.width * 15 / 100)];
    backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImg.size.width, bgImg.size.height * size)];
    [backGround setImage:rightSizeImg];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backGround.frame.size.width, backGround.frame.size.height)];
    [view setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [view addSubview:backGround];
    
    [self addSubview:view];
}

- (void)customButtonTapped{
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
        self->view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(genericPopUp:touchedButtonAtIndex:)]) {
            [self->_delegate genericPopUp:self touchedButtonAtIndex:[self->buttonsArray count]];
        }
    }];
    
}

- (UIButton*)getCustomUIButton:(NSString*)name title:(NSString*)textTitle fontStyle:(UIFont*)font colorStyle:(UIColor*)color
                     normalImg:(UIImage*)imgNormal downImg:(UIImage*)imgTouch selector:(SEL)s {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIImage imageNamed:@"button_accept"].size.width, [UIImage imageNamed:@"button_accept"].size.height)];
    [button setTitle:textTitle forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setBackgroundImage:imgNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imgTouch forState:UIControlStateHighlighted];
    [button addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)initTitleAndIconFor:(NSString *)title withW:(float)width andH:(float)height {
    if (title){
        titleGPU = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width * 4) / 100, iconGPU.frame.origin.y + ((iconGPU.frame.size.height * 150) / 100), (view.frame.size.width * 92) / 100, 200)];
        [titleGPU setText:title];
        [titleGPU setFont:[UIFont fontWithName:@"Ruda-Black" size:[GlobalFunctions getSizeForCorrectDevice:TITLE_FNT_SIZE multiplier:1]]];
        [titleGPU setNumberOfLines:0];
        [titleGPU sizeToFit];
        [titleGPU setTextColor:DEFAULT_BLACK_COLOR];
        [titleGPU setTextAlignment:NSTextAlignmentCenter];
        
        [titleGPU setFrame:CGRectMake((view.frame.size.width * (1 - TITLE_FRAME_W_RATIO)/2),
                                      (view.frame.size.height * 15) / 100,
                                      (view.frame.size.width * TITLE_FRAME_W_RATIO),
                                      titleGPU.frame.size.height)];
        [view addSubview:titleGPU];
    }
}

- (void)initMessageFor:(NSString *)msg {
    
    if (!msg)
        return;
    messageGPU = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                           view.frame.size.width * MSG_FRAME_W_RATIO,
                                                           view.frame.size.height / 2)];
    [messageGPU setCenter:CGPointMake(view.frame.size.width / 2, (view.frame.size.height * 30) / 100)];
    [messageGPU setLineBreakMode:NSLineBreakByWordWrapping];
    [messageGPU setNumberOfLines:0];
    [messageGPU setFont:[UIFont fontWithName:@"Ruda-Bold" size:[GlobalFunctions getSizeForCorrectDevice:MSG_FNT_SIZE multiplier:1]]];
    [messageGPU setText:msg];
    [messageGPU sizeToFit];
    if (messageGPU.frame.size.height > view.frame.size.height * 45 / 100) {
        [messageGPU setFrame:CGRectMake(0, 0, view.frame.size.width * MSG_FRAME_W_RATIO, view.frame.size.height * 45 / 100)];
        [messageGPU setFont:[UIFont fontWithName:@"Ruda-Bold" size:[GlobalFunctions labelforFont:@"Ruda-Bold" fontSize:MSG_FNT_SIZE size:messageGPU.frame.size text:msg lines:0 breakMode:NSLineBreakByWordWrapping]]];
        
    }
    if (!titleGPU) {
        //           CGSize sizeToFit = [msg sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Ruda-Bold" size:TITLE_FNT_SIZE]}];
        [messageGPU setFrame:CGRectMake(0, 0, view.frame.size.width * MSG_FRAME_W_RATIO + 0.08, 1000000)];
        [messageGPU setFont:[UIFont fontWithName:@"Ruda-Bold" size:[GlobalFunctions labelforFont:@"Ruda-Bold" fontSize:TITLE_FNT_SIZE size:messageGPU.frame.size text:msg lines:0 breakMode:NSLineBreakByWordWrapping]]];
        [messageGPU sizeToFit];
        
        [messageGPU setCenter:CGPointMake(view.frame.size.width / 2, (view.frame.size.height * 30) / 100)];
    }
    else{
        [messageGPU setFrame:CGRectMake(0, 0, view.frame.size.width * MSG_FRAME_W_RATIO, messageGPU.frame.size.height)];
        [messageGPU setCenter:CGPointMake(view.frame.size.width / 2, titleGPU.frame.origin.y + titleGPU.frame.size.height + (view.frame.size.height * 15) / 100)];
    }
    [messageGPU setTextColor:DEFAULT_BLACK_COLOR];
    [messageGPU setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:messageGPU];
}

- (void)initButtonsFor:(NSArray *)buttons{
    buttonsArray = [[NSMutableArray alloc] init];
    buttonW = [UIImage imageNamed:@"button_accept"];
    buttonB = [UIImage imageNamed:@"button_decline"];
    buttonWTouched = [UIImage imageNamed:@"button_accept_hover"];
    buttonBTouched = [UIImage imageNamed:@"button_decline_hover"];
    for (int ct = 0; ct < [buttons count]; ++ct) {
        UIButton *tmp;
        if (ct == 0) {
            tmp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,
                                                             buttonW.size.width, buttonW.size.height)];
        }
        else {
            tmp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,
                                                             buttonW.size.width, buttonW.size.height * 90 / 100)];
        }
        
        if (ct > 0 && _needResize && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [tmp setFrame:CGRectMake(0, 0, buttonW.size.width * 85 / 100, buttonW.size.height * 65 / 100)];
        }
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [tmp setFrame:CGRectMake(0, 0, tmp.frame.size.width * 90 / 100, tmp.frame.size.height * 90 / 100)];
        }
        [tmp setTag:ct];
        [tmp addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        NSArray *tmpArr = [buttons objectAtIndex:ct];
        
        if ([tmpArr count] > 2) { ////For rating popup custom Button with stars
            float padTextIm = 10;
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (tmp.frame.size.width * 90) / 100, (tmp.frame.size.height * 55) / 100)];
            UIImageView *imgIcn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[tmpArr objectAtIndex:2]]];
            [labelTitle setText:[tmpArr objectAtIndex:0]];
            [labelTitle setTextColor:[tmpArr objectAtIndex:1]];
            [labelTitle setFont:[UIFont fontWithName:@"Ruda-Black" size:[GlobalFunctions getSizeForCorrectDevice:BTN_Y_FNT_SIZE multiplier:1]]];
            labelTitle.minimumScaleFactor = 0.5f;
            [labelTitle setAdjustsFontSizeToFitWidth:YES];
            [labelTitle setTextAlignment:NSTextAlignmentCenter];
            [labelTitle sizeToFit];
            
            [imgIcn setFrame:CGRectMake(labelTitle.frame.size.width + padTextIm,
                                        labelTitle.center.y - imgIcn.frame.size.height/2-2, ///asset not centered
                                        imgIcn.frame.size.width,
                                        imgIcn.frame.size.height)];
            UIView *inBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelTitle.frame.size.width + padTextIm + imgIcn.frame.size.width, labelTitle.frame.size.height)];
            inBtnView.center = tmp.center;
            [inBtnView addSubview:labelTitle];
            [inBtnView addSubview:imgIcn];
            [tmp addSubview:inBtnView];
        }
        else {
            [tmp setTitle:[tmpArr objectAtIndex:0] forState:UIControlStateNormal];
            tmp.titleLabel.minimumScaleFactor = 0.5f;
            [tmp.titleLabel setFrame:CGRectMake((tmp.frame.size.width * 5) / 100, 0, (tmp.frame.size.width * 90) / 100, tmp.titleLabel.frame.size.height)];
            [tmp.titleLabel setFont:[UIFont fontWithName:@"Ruda-Black" size:[GlobalFunctions getSizeForCorrectDevice:BTN_N_FNT_SIZE multiplier:1]]];
            [tmp.titleLabel setAdjustsFontSizeToFitWidth:YES];
            [tmp.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [tmp setTitleColor:[tmpArr objectAtIndex:1] forState:UIControlStateNormal];
        }
        if (ct == 0) {
            [tmp setBackgroundImage:buttonW forState:UIControlStateNormal];
            [tmp setBackgroundImage:buttonWTouched forState:UIControlStateHighlighted];
            [tmp.titleLabel setFont:[UIFont fontWithName:@"Ruda-Black" size:[GlobalFunctions getSizeForCorrectDevice:BTN_Y_FNT_SIZE multiplier:1]]];
            
        }
        else {
            [tmp setBackgroundImage:buttonB forState:UIControlStateNormal];
            [tmp setBackgroundImage:buttonBTouched forState:UIControlStateHighlighted];
            
        }
        [tmp setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [tmp.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [buttonsArray addObject:tmp];
    }
    if ([buttonsArray count] == 1) {
        [[buttonsArray objectAtIndex:0] setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height - ((((UIButton *)[buttonsArray objectAtIndex:0]).frame.size.height * 1)))];
        [view addSubview:[buttonsArray objectAtIndex:0]];
    } else if (CustomContentType ==customTypeTextBtwBtn) {
        [[buttonsArray lastObject] setFrame:CGRectMake((view.frame.size.width * 5) / 100,
                                                       view.frame.size.height - buttonB.size.height * 1.5,
                                                       buttonB.size.width,
                                                       buttonB.size.height)];
        [view addSubview:[buttonsArray lastObject]];
        NSString * text = NSLocalizedString(@"ScoreBeaten1", nil);
        CGSize sizeToFit = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Ruda-Bold" size:11.0]}];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width * 20)/ 100,
                                                                   view.frame.size.height - buttonB.size.height * 2.5,
                                                                   (view.frame.size.width * 60) / 100,
                                                                   sizeToFit.height)];
        [label setNumberOfLines:0];
        [label setText:text];
        [label setText:text];
        [label setFont:[UIFont fontWithName:@"Ruda-Bold" size:11.0]];
        label.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0];
        [label setBackgroundColor:[UIColor clearColor]];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
    }
    else {
        for (int ct = (int)[buttonsArray count] - 1; ct >= 0  ; --ct) {
            [[buttonsArray objectAtIndex:ct] setFrame:CGRectMake((view.frame.size.width * 5) / 100, view.frame.size.height - buttonB.size.height * 1.5, buttonB.size.width, buttonB.size.height)];
            if (ct + 1 < [buttonsArray count]) {
                [[buttonsArray objectAtIndex:ct] setFrame:CGRectMake(view.frame.size.width / 2 + ((view.frame.size.width * 3) / 100),
                                                                     view.frame.size.height - buttonB.size.height * 1.5,
                                                                     buttonW.size.width, buttonW.size.height)];
            }
            
            
            [view addSubview:[buttonsArray objectAtIndex:ct]];
        }
    }
}

- (void) updateToRotationWithWidth:(CGFloat)w andHeight:(CGFloat)h duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        [self setFrame:CGRectMake(0, 0, w, h)];
        [self->view setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height /2)];
    }];
    
}

- (void) adjustElemsToNewRotationWith:(CGFloat)w and:(CGFloat)h duration:(NSTimeInterval)duration{
    
    if (iconGPU)
        [iconGPU setCenter:CGPointMake(view.frame.size.width / 2, iconGPU.center.y)];
    if (titleGPU) {
        [titleGPU setFrame:CGRectMake((view.frame.size.width) * (1 - TITLE_FRAME_W_RATIO)/2,
                                      iconGPU.frame.origin.y + iconGPU.frame.size.height + ((view.frame.size.height * 2) / 100),
                                      (view.frame.size.width * TITLE_FRAME_W_RATIO),
                                      titleGPU.frame.size.height)];
        [titleGPU setFont:[UIFont fontWithName:@"Ruda-Black" size:TITLE_FNT_SIZE]];
        [titleGPU sizeToFit];
        [titleGPU setCenter:CGPointMake(view.frame.size.width / 2, titleGPU.center.y)];
    }
    if (messageGPU) {
        [messageGPU setFrame:CGRectMake(0,
                                        titleGPU.frame.origin.y + ((titleGPU.frame.size.height * 130) / 100),
                                        view.frame.size.width * MSG_FRAME_W_RATIO,
                                        (view.frame.size.height * 3) / 100)];
        [messageGPU setFont:[UIFont fontWithName:@"Ruda-Bold" size:[GlobalFunctions getSizeForCorrectDevice:MSG_FNT_SIZE multiplier:1]]];
        [messageGPU sizeToFit];
        if (messageGPU.frame.size.height > view.frame.size.height * 35 / 100) {
            [messageGPU setFrame:CGRectMake(0, titleGPU.frame.origin.y + ((titleGPU.frame.size.height * 130) / 100), messageGPU.frame.size.width, view.frame.size.height * 35 / 100)];
            [messageGPU setFont:[UIFont fontWithName:@"Ruda-Bold" size:[GlobalFunctions labelforFont:@"Ruda-Bold" fontSize:MSG_FNT_SIZE+2 size:messageGPU.frame.size text:messageGPU.text lines:0 breakMode:NSLineBreakByWordWrapping]]];
        }
        [messageGPU setCenter:CGPointMake(view.frame.size.width / 2, messageGPU.center.y)];
    }
    if (accGPU) {
        [accGPU setFrame:CGRectMake(accGPU.frame.origin.x, messageGPU.frame.origin.y + (messageGPU.frame.size.height * 130) / 100, accGPU.frame.size.width, accGPU.frame.size.height)];
        [accGPU setCenter:CGPointMake(view.frame.size.width / 2, accGPU.center.y)];
    }
    [self adjustButtonsToNewRotation];
}

- (void) adjustButtonsToNewRotation {
    for (int ct = (int)[buttonsArray count] - 1; ct < [buttonsArray count]; --ct) {
        UIButton *tmpBtn = ((UIButton *)[buttonsArray objectAtIndex:ct]);
        if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (tmpBtn.frame.size.width * 90) / 100 , (tmpBtn.frame.size.height * 90) / 100)];
            if (_needResize && ct > 0) {
                [tmpBtn setFrame:CGRectMake(0, 0, buttonW.size.width * 85 / 100, buttonW.size.height * 65 / 100)];
            }
        }
        else {
            if (ct > 0)
                [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (buttonW.size.width * 100) / 100 , (buttonW.size.height * 90) / 100)];
            else
                [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (buttonW.size.width * 100) / 100 , (buttonW.size.height * 100) / 100)];
        }
        if (ct + 1 == [buttonsArray count]) {
            [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2 ,
                                          view.frame.size.height - (buttonW.size.height * 0.9))];
            if (_needResize && !UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
                [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2 ,
                                              view.frame.size.height - (buttonW.size.height * 0.5))];
        }
        else
            [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2,
                                          ((UIButton *)[buttonsArray objectAtIndex:ct + 1]).frame.origin.y - (tmpBtn.frame.size.height * 0.7))];
    }
}

- (void) initButtonsToNewRotation {
    for (int ct = (int)[buttonsArray count] - 1; ct < [buttonsArray count]; --ct) {
        UIButton *tmpBtn = ((UIButton *)[buttonsArray objectAtIndex:ct]);
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (tmpBtn.frame.size.width * 90) / 100 , (tmpBtn.frame.size.height * 90) / 100)];
            if (_needResize && ct > 0) {
                [tmpBtn setFrame:CGRectMake(0, 0, buttonW.size.width * 85 / 100, buttonW.size.height * 65 / 100)];
            }
        }
        else {
            if (ct > 0)
                [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (buttonW.size.width * 100) / 100 , (buttonW.size.height * 90) / 100)];
            else
                [tmpBtn setFrame:CGRectMake(tmpBtn.frame.origin.x, tmpBtn.frame.origin.y, (buttonW.size.width * 100) / 100 , (buttonW.size.height * 100) / 100)];
        }
        if (ct + 1 == [buttonsArray count]) {
            [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2 ,
                                          view.frame.size.height - (buttonW.size.height * 0.9))];
            if (_needResize && !UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
                [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2 ,
                                              view.frame.size.height - (buttonW.size.height * 0.5))];
        }
        else
            [tmpBtn setCenter:CGPointMake(view.frame.size.width / 2,
                                          ((UIButton *)[buttonsArray objectAtIndex:ct + 1]).frame.origin.y - (tmpBtn.frame.size.height * 0.7))];
    }
}

- (void) buttonTapped:(id)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0];
        self->view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self->_delegate genericPopUp:self touchedButtonAtIndex:[sender tag]];
    }];
}

- (void) setNeedResize:(BOOL)val {
    _needResize = val;
}
@end
