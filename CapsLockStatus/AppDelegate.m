//
//  AppDelegate.m
//  CapsLockStatus
//
//  Created by Chris Stringer on 3-7-17.
//  Copyright © 2017 Chris Stringer. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSStatusItem  *statusItem;
@property (strong, nonatomic) NSTimer       *timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // create status item, set props
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    if (self.statusItem == nil)
        {
        NSLog(@"Error creating status item");
        return;
        }
    self.statusItem.title = CLS_STATUS_TEXT_OFF;

    // create a menu, add 'Quit' item, assign to status item
    NSMenu *menu = [[NSMenu alloc] init];
    if (menu == nil)
        {
        NSLog(@"Error initializing menu");
        return;
        }
    [menu addItemWithTitle:@"Quit CapsLockStatus"
                    action:@selector(terminate:)
             keyEquivalent:@""];
    self.statusItem.menu = menu;

    // start event polling timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CLS_POLL_INTERVAL
                                                  target:self
                                                selector:@selector(onTimerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    if (self.timer == nil)
        {
        NSLog(@"Error initializing timer");
        return;
        }
    
    [self onTimerUpdate];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    if (self.timer != nil)
        {
        [self.timer invalidate];
        }
    self.timer = nil;
}


- (void)onTimerUpdate
{
    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    
    if (event.modifierFlags == 256)
        {
        self.statusItem.title = CLS_STATUS_TEXT_OFF;
        [self.statusItem.button highlight:NO];
        }
    else
        {
        self.statusItem.title = CLS_STATUS_TEXT_ON;
        [self.statusItem.button highlight:YES];
        }
}

@end
