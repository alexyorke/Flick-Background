//
//  checkInternetConnection.m
//  Flick Background
//
//  Created by Alex Yorke on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "checkInternetConnection.h"
#import "Flick_BackgroundAppDelegate.h"

@implementation Flick_BackgroundAppDelegate(checkInternetConnection)
- (void) checkInternetConnection: (BOOL *) connected_p  {
  BOOL success;

SCNetworkConnectionFlags status;
success = SCNetworkCheckReachabilityByName("www.flickr.com", &status);
*connected_p = success && (status & kSCNetworkFlagsReachable) && !(status
& kSCNetworkFlagsConnectionRequired);
	return *connected_p;
}
@end
