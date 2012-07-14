//
//  Flick_BackgroundAppDelegate.m
//  Flick Background
//
//  Created by Alex Yorke on 10-11-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Flick_BackgroundAppDelegate.h"
#import "UpdateUI.h"
#import "initalizeMenuItem.h"
#import "NSImage-PropotionalScaling.h"

@implementation Flick_BackgroundAppDelegate

static float IMAGE_MULTIPLIER = 3.5f;

NSUserDefaults *prefs                       = nil;
NSFileManager  *fileManager                 = nil;
NSString       *applicationSupportDirectory = nil;

+ (void)initialize {
    if(!prefs) {
        prefs = [NSUserDefaults standardUserDefaults];
    }
    if (!fileManager) {
        fileManager = [NSFileManager defaultManager];
        
    }
    
    if (!applicationSupportDirectory) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        if ( [paths count] == 0 ) {
            NSRunAlertPanel(@"Error",
                            @"The application support folder could not be created.  Flick Background must quit, because it will not be able to store the needed files for the application to run.  To resolve this issue, try repairing permissions using disk utility or contact the administrator.",
                            @"Quit",
                            nil, nil);
            [[NSApplication sharedApplication] terminate:self];
            
        } else {
            applicationSupportDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Flick Background"];
        }
        
    }
    
    
}
- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	BOOL isDir;
    
	if (![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:&isDir]) {
		[fileManager createDirectoryAtPath: applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        // The application support folder is missing.  Seems like this is the first time launching the application.
        
        // Disable the buttons that the user wouldn't be able to click on (change desktop) because there isn't a desktop to change it to!
        [setDesktop       setEnabled:NO];
		[switchAndSet     setEnabled:NO];
		[openInFlickr     setEnabled:NO];
        
	}
	
	NSString *desktop_name = [prefs stringForKey:@"desktopName"];
    
	if (desktop_name) {
        
		NSString *  image_path      = [applicationSupportDirectory stringByAppendingPathComponent:desktop_name];
        
		NSImage  *  imageFromBundle = [[NSImage alloc] initWithContentsOfFile:image_path];
        NSData   *  imageContents   = [[NSData alloc ] initWithContentsOfFile:image_path];
            
        NSImage  *  thumbnail       = [imageFromBundle imageByScalingProportionallyToSize:NSMakeSize(1000,1000)];
        
        [self dataIsValidJPEG: imageContents] ? [ViewImage setImage: thumbnail] : [self recoverFromCorruptImageFileWhileApplicationWasTerminating];
 
    
    // Initalize menu item
    [self initMenuItem];
    

}
    
}


- (IBAction)changeBackground:(id)sender 
{
    
	
	[self updateUI:YES];
    
    [MyWindow display];
    
	NSString *download_url = [self parseFlickrRSS];
	
    
    [prefs setObject:download_url forKey:@"directImageUrl"];
	NSURL *URL = [NSURL URLWithString:download_url];
	WebDownload *theDownload = [[WebDownload alloc] initWithRequest:[NSURLRequest requestWithURL:URL] delegate:self];
	
}






- (IBAction)rebuildDatabase:(id)sender {
	
	NSString *alert_title    = @"Rebuild Database";
	NSString *alert_message  = @"Rebuilding the database will erase the Flick Background database and your desktop cache.  It is recommended that you get a new background picture after performing this operation.";
	NSString *button_confirm = @"Rebuild";
	NSString *button_cancel  = @"Cancel";
	
	int alertReturn = NSRunAlertPanel(alert_title, alert_message, button_confirm, button_cancel, nil);
	
	if (alertReturn == NSAlertDefaultReturn) {
		[fileManager removeItemAtPath: applicationSupportDirectory error:nil];
		[fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
}

- (void)disableIU {
    
    [setDesktop       setEnabled:NO];
    [switchAndSet     setEnabled:NO];
    [changeBackground setEnabled:NO];
    [openInFlickr     setEnabled:NO];
    [MyWindow update];
    
    [[NSAnimationContext currentContext] setDuration:0.25];  //2 second fade
    [[ViewImage animator] setAlphaValue:0.25f];  //fade in view to full
    [progressIndicator setUsesThreadedAnimation:YES];
    [progressIndicator startAnimation:self];
    [[NSAnimationContext currentContext] setDuration:0.25];
    
    [[progressIndicator animator] setAlphaValue:1.00f];

    
}

- (void)enableIU {
    
    [setDesktop         setEnabled:YES];
    [changeBackground   setEnabled:YES];
    [openInFlickr       setEnabled:YES];
    
    [[NSAnimationContext currentContext] setDuration:0.25];  //2 second fade
    [[ViewImage animator] setAlphaValue:1.0f];  //fade in view to full
    [[NSAnimationContext currentContext] setDuration:0.25];
    [[progressIndicator animator] setAlphaValue:0.00f];
    [progressIndicator stopAnimation:self];
    
}




// This is glue code.  All other methods that rely on updateUI should be changed
// to enableUI and disableUI.
- (void)updateUI: (BOOL)isStart {
    
     (isStart) ? [self disableIU] : [self enableIU];
}


- (IBAction)setDesktop:(id)sender {
	
    
	NSString *desktop_name  = [prefs stringForKey:@"desktopName"];
	if ([prefs stringForKey:@"dpiWarning"] == @"NO") {
		
		int alertReturn = NSRunAlertPanel(@"DPI Warning", @"This image has dimentions lower than your screen.", @"OK", @"Cancel", nil);
		
		if (alertReturn == NSAlertDefaultReturn) {
			if (desktop_name != nil) {
				[self performDesktopSwitch:desktop_name];
			} else { NSRunAlertPanel(@"Error", @"Please click on the arrow at the bottom to get a desktop!", @"OK", nil, nil); }	
		}
	}
	
}

- (IBAction)openInFlickr:(id)sender {
    
	NSString *photo_url = [prefs stringForKey:@"photoUrl"];
	if (photo_url != nil) {
		[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:photo_url]];
		
	}else{
		NSRunAlertPanel(@"Error", @"Please click on the arrow at the bottom to get a desktop!", @"Ok", nil, nil);
	}
	
}


- (void) dealloc {
	(__bridge_retained CFTypeRef)(statusItem);
}




- (void)downloadDidBegin:(NSURLDownload *)theDownload {
	
	NSString *desktop_name = [NSString stringWithFormat: @"desktop%d.jpg", arc4random()];
	[theDownload setDestination: [applicationSupportDirectory stringByAppendingPathComponent:desktop_name] allowOverwrite:YES];
	
	NSString *previousFileName = [prefs stringForKey:@"desktopName"];
	
	@try {
		
		[fileManager removeItemAtPath: [applicationSupportDirectory stringByAppendingPathComponent:previousFileName] error:nil];
		[prefs setObject:desktop_name forKey:@"desktopName"];
	}
	
    @catch (NSException *theError) {NSLog(@"A small error occured when reading the preference key desktopName.  This is okay.  ERROR: %@", theError);}
	@finally {}
	
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageBeganDownloading" object:nil];
}


- (void)downloadDidFinish:(WebDownload *)theDownload {
	NSString *desktop_name = [prefs stringForKey:@"desktopName"];
	
	NSString *image_path = [applicationSupportDirectory stringByAppendingPathComponent:desktop_name];
	
	NSImage *imageFromBundle = [[NSImage alloc] initWithContentsOfFile:image_path];
    
	
	[ViewImage setImage: imageFromBundle];
	[self updateUI:NO];
	
}



- (void)download:(NSURLDownload *)theDownload didFailWithError:(NSError *)error
{
    NSString *errorDescription = [error localizedDescription];
    if (!errorDescription) {
        errorDescription = @"An unknown error occured during download.  Please try again.  If the issue persists, make sure that you have a reliable internet connection, and you have permission to view www.flickr.com";
    }
    
    NSBeginAlertSheet(@"Download Failed", nil, nil, nil, [self MyWindow], nil, nil, nil, nil, errorDescription);
	
	[self updateUI:NO];
}






// Sandbox code
// ============

// In an event that the application folder is deleted, the preference file will still contain
// the direct image link to the photo.  My application needs to redownload the photo.
// If the photo doesn't exist, tell the user and download a new one straight away.


-(BOOL)dataIsValidJPEG:(NSData *)data
{
    if (!data || data.length < 2) return NO;
    
    NSInteger totalBytes = data.length;
    const char *bytes = (const char*)[data bytes];
    
    return (bytes[0] == (char)0xff && 
            bytes[1] == (char)0xd8 &&
            bytes[totalBytes-2] == (char)0xff &&
            bytes[totalBytes-1] == (char)0xd9);
}

// From http://stackoverflow.com/questions/3848280/catching-error-corrupt-jpeg-data-premature-end-of-data-segment
    
    
-(void)recoverFromCorruptImageFileWhileApplicationWasTerminating {
    
    [self changeBackground:self];
    
}
// End sandbox code





// Synthesizers...

@synthesize MyWindow;
@synthesize changeBackground;
@synthesize rebuildDatabase;
@synthesize ViewImage;
@synthesize statusMenu;
@synthesize statusItem;
@synthesize statusImage;
@synthesize statusHighlightImage;
@synthesize statusNoInternetImage;
@synthesize statusText;
@synthesize download;
@synthesize openInFlickr;
@synthesize setDesktop;
@synthesize switchAndSet;
@synthesize tags;
@synthesize changeBackgroundButton;
@synthesize quality;
@synthesize dpiWarning;
@synthesize progressIndicator;
@synthesize author;
@synthesize _isDataSourceAvailable;
@synthesize webView;
@synthesize window;
@synthesize hasApplicationLaunchedTracker;

@end
