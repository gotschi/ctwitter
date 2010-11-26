//
//  clientAppDelegate.h
//  client
//
//  Created by Manuel Gottstein on 14.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface clientAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	IBOutlet NSTextField *serverIp;
	IBOutlet NSTextField *messageBox;
	IBOutlet NSScrollView *messageList;
	IBOutlet NSButton *sendButton;
}

-(IBAction) connect: (id) sender;
-(IBAction) sendMessage: (id) sender;
-(IBAction) enableMessageBox:(id)sender;
-(IBAction) clearIP:(id) sender;

@property (assign) IBOutlet NSWindow *window;

@end