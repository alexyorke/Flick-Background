#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
@class DesktopDelegate;
@interface DesktopDelegate : NSObject {

NSScreen *curScreen;

}
- (void) flickToFile;
- (NSString *) parseFlickrRSS;
@property (retain) NSScreen *curScreen;
@end
