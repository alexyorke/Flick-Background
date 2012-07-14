//
//  Rain.m
//  Flick Background
//
//  Created by Alex Yorke on 30/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Rain.h"
#import "Flick_BackgroundAppDelegate.h"

@implementation Raindrop

- (NSString *) condenseCloudWithRainDrop: (NSString *) theUrl toFile: (NSString *) filePath {
    
	NSError *urlError = nil;
	NSData *initalizedUrl = [NSData dataWithContentsOfURL: [NSURL URLWithString:theUrl] options:0 error:&urlError];
    
	if (urlError != nil) {
		NSRunAlertPanel(
                        @"Download Failed",
                        @"The download could not be completed because you are not connected to the internet.",
                        @"OK",
                        nil, nil);
	} else {
        
        NSString *initalizedContents = [ [[NSString alloc] initWithData:initalizedUrl encoding:NSUTF8StringEncoding] autorelease];
        
        if (filePath == @"") {
            
            return initalizedContents;
            
        } else {
            
            NSString *applicationFolderAppendedWithFileName = [[ self applicationSupportFolder] stringByAppendingPathComponent:filePath];
            
            [initalizedContents writeToFile:applicationFolderAppendedWithFileName
                                 atomically:YES encoding:NSUnicodeStringEncoding
                                      error:&urlError];
            
            if (urlError != nil) {
                
                NSRunAlertPanel(
                                @"File write error",
                                [NSString stringWithFormat: @"The file could not be written to disk.  It is strongly recommended that this is sent to the developer, so that it can be fixed.  This is what happened: %@", urlError],
                                @"Send",
                                @"Do not send", nil);	
                
            }
            
        }
    }
    return 0;
}

- (NSString *)applicationSupportFolder {
	
    NSString *applicationSupportFolder = nil;
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if ( [paths count] == 0 ) {
        NSRunAlertPanel(@"Error", @"The application support folder could not be created.  Flick Background must quit, because it will not be able to store the needed files for the application to run.  To resolve this issue, try repairing permissions using disk utility or contact the administrator.", @"Quit", nil, nil);
        [[NSApplication sharedApplication] terminate:self];
    } else {
        applicationSupportFolder = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Flick Background"];
    }
    return applicationSupportFolder;
}

@end
