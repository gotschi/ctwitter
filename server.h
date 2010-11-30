//
//  Server.h
//  cTwitterServer
//
//  Created by Dominik Guzei on 29.11.10.
//  Copyright 2010 Fh Salzburg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface Server : NSObject {

@private
	NSString *ip;
	in_port_t port;
	BOOL connected;
	BOOL started;
	struct sockaddr_in serverAddress;
	int serverSocketFileDescriptor;
	int highestSocketFileDescriptor;
}

@property (readonly, getter=isConnected) BOOL connected;
@property (readonly, getter=hasStarted) BOOL started;
- (id) initWithIp: (NSString *) theIp 
		   onPort: (int) thePort;

- (void) start;
- (void) handleReadFileDescriptors;
@end
