//
//  Quicklook.m
//  Flick Background
//
//  Created by Alex Yorke on 31/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Quicklook.h"


@implementation Quicklook
- (void) quicklook_this: (NSString *) image_path pointer: (NSImageView *)quicklookImage_p wpointer: (NSWindow *)quicklookWindow_p {
	NSImage *imageFromBundle = [[[NSImage alloc] initWithContentsOfFile:image_path] autorelease];
	
	[quicklookImage_p setImage: imageFromBundle];
	
	[quicklookWindow_p makeKeyAndOrderFront:self];

	
}


@end
