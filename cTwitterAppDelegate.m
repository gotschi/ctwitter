//
//  XcodeAppDelegate.m
//  Xcode
//
//  Created by Manuel Gottstein on 08.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cTwitterAppDelegate.h"

@implementation cTwitterAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	
}

/**
 * Action to start the server with given ip and port
 */

- (IBAction)startServer: (id)sender 
{
	if(!server.started) {
		
		// get values from textfields
		serverIp = @"127.0.0.1";
		port = 9000;
		
		server = [[Server alloc] initWithIp: serverIp onPort: port];

		if(server) {
			NSLog(@"server was successfully setup");
			
			// start listening for clients
			[server start];
		}
	}
}

@end
