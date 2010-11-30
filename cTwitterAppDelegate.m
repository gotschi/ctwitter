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
		NSString *ipString = [serverIp stringValue];
		NSString *portString = [serverPort stringValue];
		NSLog(@"ip: %@, port: %@", ipString, portString);
		
		server = [[Server alloc] initWithIp: ipString onPort: [portString intValue]];

		if(server) {
			NSLog(@"server was successfully setup");
			
			// start listening for clients
			[server start];
		}
	}
}

@end
