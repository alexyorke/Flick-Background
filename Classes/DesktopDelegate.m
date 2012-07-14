//
//  DesktopDelegate.m
//  Flick Background
//
//  Created by Alex Yorke on 02/09/10.
//  Copyright 2010 None. All rights reserved.
//

#import "DesktopDelegate.h"
#import "Rain.h"
#import "Flick_BackgroundAppDelegate.h"
#import "SZJsonParser.h"

@implementation Flick_BackgroundAppDelegate(DesktopDelegate)

static NSString *RSSURL = @"http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=";
static NSString *flickrDefaultFilenameExtension = @".jpg";


- (void) performDesktopSwitch: (NSString *) desktop_name {
    NSDictionary *errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
	NSString *compiled_script = [NSString stringWithFormat: @"\
								 set desktop_name to \"%@\"\n\
								 tell application \"System Events\" to set picture of desktop 1 to (path to home folder as string) & \"Library:Application Support:Flick Background:\" & desktop_name", desktop_name];
    NSAppleScript* scriptObject = [[[NSAppleScript alloc] initWithSource: compiled_script] autorelease];
	returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
	if (returnDescriptor == NULL)
	{
		NSRunAlertPanel(@"Error",
                        [NSString stringWithFormat:@"Flick Background tried to change your desktop picture.  Unfortunately, it could not change it because an error occured.  This issue may be because you are running a version of Mac OS X that is incompatible with Flick Background, or you do not have System Events installed.  Here is an error log of what happened: %@", errorDict],
                        @"OK",
                        nil, nil);
	}
	
}

- (NSString *) parseFlickrRSS {
    
	Raindrop *drop = [[Raindrop alloc] init];
    Raindrop *drop_two = [[Raindrop alloc] init];
    
    
	NSString *rawRSSFeed = [drop condenseCloudWithRainDrop:RSSURL
                                                     toFile:@""];
    
    NSString *linkToPhotoPage = [[rawRSSFeed componentsSeparatedByString:@"<link>"] objectAtIndex:3];
    NSString *linkToPhotoPageTrimmed = [[linkToPhotoPage componentsSeparatedByString:@"</link>"] objectAtIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:linkToPhotoPageTrimmed forKey:@"photoUrl"];
    
    NSString *TESTTEXT = [drop_two condenseCloudWithRainDrop:linkToPhotoPageTrimmed 
                                                      toFile:@""];
    
    NSString *jsonFrontPiece = [[TESTTEXT componentsSeparatedByString:@"Y.photo.init("] objectAtIndex:1];
    NSString *source = [[[jsonFrontPiece componentsSeparatedByString:@":null}},"] objectAtIndex:0] stringByAppendingString:@":null}},"];

    id *obj = [source jsonObject];
    
    NSArray *values = [obj allValues];
    
    values = [values objectAtIndex:12];
    
    
    int x = 0;
    
    NSArray *nextItem = [NSArray arrayWithObjects:@"c", @"h", @"k", @"l", @"m", @"n", @"o", @"q", @"s", @"sq", @"t", @"z", nil];
    NSInteger *maxPixels = 0;
    NSInteger *maxXValue = 0;
    while (x<12) {
        
        NSString *test =   [values objectForKey:[nextItem objectAtIndex:x]];
        
        NSString *height = [test objectForKey:@"height"];
        
        NSString *width =  [test objectForKey:@"width"];
        
        NSInteger *heightWidth = [height intValue] * [width intValue];
        
        
        // http://stackoverflow.com/questions/4807985/convert-nsstring-to-integer-in-objective-c
        
        
        if (heightWidth > maxPixels) {
            
            maxPixels = heightWidth;
            maxXValue = x;
        }
        
        
        x++;
    }
    
    
    
    return [[values objectForKey: [nextItem objectAtIndex:maxXValue]] objectForKey:@"url"];
}



@end
