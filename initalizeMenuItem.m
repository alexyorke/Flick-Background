//
//  initalizeMenuItem.m
//  Flick Background
//
//  Created by Alex Yorke on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "initalizeMenuItem.h"
#import "Flick_BackgroundAppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>


@implementation Flick_BackgroundAppDelegate(initalizeMenuItem)
- (void) initMenuItem {
	
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    
    NSImage* statusImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon-alt" ofType:@"png"]];
    
    [statusImage setSize:NSMakeSize(20, 20)];
    
    [statusItem setImage:[statusImage retain]];
	
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
	[statusItem setMenu:statusMenu];
	[statusItem setToolTip:@"Flick Background 0.92"];
	[statusItem setHighlightMode:YES];
	
    
    /* Check the internet connection
    SCNetworkReachabilityRef target;
    SCNetworkConnectionFlags flags = 0;
    target = SCNetworkReachabilityCreateWithAddress(NULL, "www.flickr.com");
    bool internetConnected = SCNetworkReachabilityGetFlags(target, &flags);
    //CFRelease(target);
     End check internet connection
    
    
	if (internetConnected) {
        
        [statusItem setImage:statusImage];
        
    } else {
        [statusItem setImage:statusNoInternetImage];
        
    }*/
	
	
}
@end
