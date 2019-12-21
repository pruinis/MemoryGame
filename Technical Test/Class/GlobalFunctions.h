#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    iPad,
    iPhone
} DeviceType;

@interface GlobalFunctions : NSObject
+ (CGFloat)getSizeForCorrectDevice:(CGFloat)initialSize multiplier:(CGFloat)mult;
+ (CGFloat)labelforFont:(NSString *)fontName fontSize:(NSInteger)fontSize size:(CGSize)size text:(NSString *)text lines:(NSInteger)nbLines breakMode:(NSLineBreakMode)breakMode;

@end
