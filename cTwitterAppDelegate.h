//
//  XcodeAppDelegate.h
//  Xcode
//
//  Created by Manuel Gottstein on 08.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface cTwitterAppDelegate : NSObject <NSApplicationDelegate> {
	
    NSWindow *window;
	
	Boolean serverStarted;
	
	IBOutlet NSTextField *serverIp;
	IBOutlet NSTextField *serverPort;
	IBOutlet NSButton *startButton;
	
	IBOutlet NSScrollView *clientList;
	IBOutlet NSScrollView *messageList;
}

+ (NSString *) ErrorDomain;
+ (int) SocketFileDescriptionError;
+ (int) BindingSocketError;
+ (NSDictionary *)dictionaryWithDescription: (NSString *)description
							  andSuggestion: (NSString *)suggestion;

- (Boolean)startServerWithIp: (NSString *)ip 
					  onPort:(NSString *)thePort 
				   withError:(NSError **)error;

- (IBAction) startServer: (id) sender;

@property (assign) IBOutlet NSWindow *window;

@end
