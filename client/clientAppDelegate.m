//
//  clientAppDelegate.m
//  client
//
//  Created by Manuel Gottstein on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "clientAppDelegate.h"

@implementation clientAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)sendMessage:(id)sender {
	
}

- (void)enableMessageBox:(id)sender {
	[messageBox setEnabled: YES];
	[sendButton setEnabled: YES];
	[messageList setEnabled: YES];
}

-(void) clearIP:(id)sender {
	[serverIp setStringValue:@""];
}

- (void)connect:(id)sender {
	[self enableMessageBox:sender];
}

@end
