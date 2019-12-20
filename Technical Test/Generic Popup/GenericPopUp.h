#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, iCarouselType)
{
    customTypeNone = 0,
    customTypeMenuBtnTopRight = 1,
    customTypeTextBtwBtn = 2,
};


@class GenericPopUp;

@protocol GenericPopUpDelegate <NSObject>

@optional
- (void) genericPopUp:(GenericPopUp *)gPopUp touchedButtonAtIndex:(NSInteger)btnIndex;
- (void) genericPopUpWillHide:(GenericPopUp *)gPopUp;

@end

@interface GenericPopUp : UIView {
    UIView *view, *bgAlpha;
    UILabel *titleGPU, *messageGPU, *accGPU;
    NSMutableArray *buttonsArray;
    UIImageView *iconGPU, *backGround;
    UIImage *buttonW, *buttonWTouched, *buttonB, *buttonBTouched;
    UIButton *closeBtn, *ptrReplayBtn;
    BOOL    _needResize;
}

@property (nonatomic, retain) id<GenericPopUpDelegate> delegate;

// Each button is a NSArray composed of a test and an UIColor like this : [NSArray arrayWithObjects:@"Button", [UIColor whiteColor]

- (id)initWithTitle:(NSString *)title message:(NSString *)msg accessory:(NSString *)acc withButtons:(NSArray *)buttonsArr size:(CGFloat)size andDelegate:(id)delegate needResize:(BOOL)val andCanHide:(BOOL)canHide;
- (id)initWithTitle:(NSString *)title message:(NSString *)msg accessory:(NSString *)acc withButtons:(NSArray *)buttons size:(CGFloat)size andDelegate:(id)delegate needResize:(BOOL)val andCustomContent:(NSInteger) customContentType andCanHide:(BOOL)canHide;

- (void)showWithDelay:(NSTimeInterval)delay and:(NSTimeInterval)duration inController:(UIViewController *)ctrl;

- (void)hide;

- (void) updateToRotationWithWidth:(CGFloat)w andHeight:(CGFloat)h duration:(NSTimeInterval)duration;

- (void) setNeedResize:(BOOL)val;

@end
