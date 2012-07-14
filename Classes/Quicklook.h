//
//  Quicklook.h
//  Flick Background
//
//  Created by Alex Yorke on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Quicklook : NSObject {}
- (void) quicklook_this: (NSString *) image_path pointer: (NSImageView *)quicklookImage_p wpointer: (NSWindow *)quicklookWindow_p;
@end
