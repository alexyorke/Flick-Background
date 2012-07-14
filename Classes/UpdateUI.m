//
//  UpdateUI.m
//  Flick Background
//
//  Created by Alex Yorke on 10-11-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpdateUI.h"


@implementation Flick_BackgroundAppDelegate(UpdateUI)
- (void)updateUI: (BOOL)isStart {
	if (isStart) {
		[setDesktop setEnabled: NO];
		[switchAndSet setEnabled:NO];
		//[quicklookButton setEnabled:NO];
		[changeBackground setEnabled:NO];
		[openInFlickr setEnabled:NO];
		
		
		[[NSAnimationContext currentContext] setDuration:0.25];  //2 second fade
		[[ViewImage animator] setAlphaValue:0.25f];  //fade in view to full
		//[[statusText animator] setAlphaValue:0.1f];
		//[[author animator] setAlphaValue:0.1f];
		[progressIndicator setUsesThreadedAnimation:YES];
		[progressIndicator startAnimation:self];
		
		
	} else {
		[progressIndicator stopAnimation:self];
		
		[setDesktop setEnabled: YES];
		[switchAndSet setEnabled:YES];
		//[quicklookButton setEnabled:YES];
		[changeBackground setEnabled:YES];
		[openInFlickr setEnabled:YES];
		
		[[NSAnimationContext currentContext] setDuration:0.25];  //2 second fade
		[[ViewImage animator] setAlphaValue:1.0f];  //fade in view to full
		
		//[[statusText animator] setAlphaValue:0.8f];
		
		
	}
}
@end
