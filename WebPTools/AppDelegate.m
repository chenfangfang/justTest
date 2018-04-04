//
//  AppDelegate.m
//  WebPTools
//
//  Created by 陈方方 on 2017/10/24.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    NSWindow * mainWindow = [NSApplication sharedApplication].mainWindow;
    [mainWindow setTitle:@"动起来"];
    [mainWindow setFrame:CGRectMake(500, 100, ViewWidth, ViewHeight) display:YES];
    [mainWindow setMinSize:CGSizeMake(ViewWidth, ViewHeight)];
    [mainWindow setMaxSize:CGSizeMake(ViewWidth, ViewHeight)];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
