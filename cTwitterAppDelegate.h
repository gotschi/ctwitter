//
//  XcodeAppDelegate.h
//  Xcode
//
//  Created by Manuel Gottstein on 08.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

@interface cTwitterAppDelegate : NSObject <NSApplicationDelegate> {
	
    NSWindow *window;
	
	Server *server;
	
	IBOutlet NSTextField *serverIp;
	IBOutlet NSTextField *serverPort;
	IBOutlet NSButton *startButton;
	
	IBOutlet NSScrollView *clientList;
	IBOutlet NSScrollView *messageList;
}

- (IBAction) startServer: (id) sender;

@property (assign) IBOutlet NSWindow *window;

@end
