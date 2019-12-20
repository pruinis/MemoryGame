#import "GlobalFunctions.h"

@implementation GlobalFunctions

+ (CGFloat)getSizeForCorrectDevice:(CGFloat)initialSize multiplier:(CGFloat)mult {
    return initialSize;
}

+ (CGFloat)labelforFont:(NSString *)fontName
               fontSize:(NSInteger)fontSize
                   size:(CGSize)size
                   text:(NSString *)text
                  lines:(NSInteger)nbLines
              breakMode:(NSLineBreakMode)breakMode{
    for (NSInteger i=fontSize-1; i>0; i--) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [lb setText:text];
        [lb setFont:[UIFont fontWithName:fontName size:fontSize]];
        lb.numberOfLines = nbLines;
        lb.lineBreakMode = breakMode;
        [lb sizeToFit];
        
        if (lb.frame.size.width <= size.width && lb.frame.size.height <= size.height) {
            return fontSize;
        }
        fontSize--;
    }
    return 0;
}

@end
