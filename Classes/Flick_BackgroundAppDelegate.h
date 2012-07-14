//
//  Flick_BackgroundAppDelegate.h
//  Flick Background
//
//  Created by Alex Yorke on 10-11-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SCNetwork.h>

#import "UpdateUI.h"
#import "initalizeMenuItem.h"
@class WebDownload;

@interface Flick_BackgroundAppDelegate : NSWindowController { //<NSApplicationDelegate> {
    
    // Is window the same as MyWindow?
    NSWindow *__unsafe_unretained window;

    
    
    
    
	IBOutlet NSWindow       * __unsafe_unretained MyWindow;
	IBOutlet NSImageView    * __weak ViewImage;
    
    
    
    
    // Menu Item
	IBOutlet NSMenu         * __weak statusMenu;
	NSStatusItem            * __weak statusItem;
	NSImage                 * __unsafe_unretained statusImage;
	NSImage                 * __unsafe_unretained statusHighlightImage;
	NSImage                 * __unsafe_unretained statusNoInternetImage;
   
    
    // Other helper-items
	WebDownload             *__weak download;
    NSProgressIndicator *progressIndicator;
    __weak WebView *webView;
    
    
    
    
    // NSButtons
    IBOutlet NSButton       *__weak openInFlickr;
	IBOutlet NSButton       *__weak setDesktop;
	IBOutlet NSButton       * __weak switchAndSet;
    NSButton                * __weak changeBackgroundButton;
    IBOutlet NSButton       * __weak changeBackground;
    
    
    
    
    // Unused
    IBOutlet NSButton       * __weak rebuildDatabase;
    NSTextField             * __weak quality;
	IBOutlet NSTextField    * __weak statusText;
	IBOutlet NSTextField    * __weak author;
	BOOL _isDataSourceAvailable;
	IBOutlet NSTextField    * __weak tags;
	IBOutlet NSTextField    * __weak dpiWarning;
    
}


- (IBAction)    changeBackground:       (id)sender;
- (IBAction)    rebuildDatabase:        (id)sender;
- (IBAction)    setDesktop:             (id)sender;
- (IBAction)    openInFlickr:           (id)sender;
- (IBAction)    switchAndSet:           (id)sender;
- (NSString *)  applicationSupportFolder;
- (NSString *)  parseFlickrRSS;
- (void)        initMenuItem;
- (void)        performDesktopSwitch:   (NSString *) desktop_name;
- (BOOL)        dataIsValidJPEG:        (NSData *)   data;


@property   (unsafe_unretained) NSWindow *   window;
@property   (unsafe_unretained) NSWindow *   MyWindow;
@property   (weak) NSButton *                changeBackground;
@property   (weak) NSButton *                rebuildDatabase;
@property   (weak) NSImageView *             ViewImage;
@property   (weak) NSMenu *                  statusMenu;
@property   (weak) NSStatusItem *            statusItem;
@property   (weak) WebView *                 hasApplicationLaunchedTracker;
@property   (unsafe_unretained) NSImage *    statusImage;
@property   (unsafe_unretained) NSImage *    statusHighlightImage;
@property   (unsafe_unretained) NSImage *    statusNoInternetImage;
@property   (weak) NSTextField *             statusText;
@property   (weak) WebDownload *             download;
@property   (weak) NSButton *                openInFlickr;
@property   (weak) NSButton *                setDesktop;
@property   (weak) NSButton *                switchAndSet;
@property   (weak) NSTextField *             tags;
@property   (weak) NSButton *                changeBackgroundButton;
@property   (weak) NSTextField *             quality;
@property   (weak) NSTextField *             dpiWarning;
@property   (weak) NSTextField *             author;
@property   BOOL                             _isDataSourceAvailable;
@property   (weak) IBOutlet WebView *        webView;


@property   (strong) IBOutlet NSProgressIndicator *progressIndicator;
@end
