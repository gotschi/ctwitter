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

	NSString *ip;
	in_port_t port;
	BOOL connected;
	BOOL started;
	
	struct sockaddr_in serverAddress;
	struct sockaddr_in clientAddress;
	
	int serverSocketFileDescriptor;
	int highestSocketFileDescriptor;
	
	// file descriptor sets to keep track
	// of incoming messages
	fd_set mainReadSet;
	fd_set currentReadSet;
}

@property (readonly, getter=isConnected) BOOL connected;
@property (readonly, getter=hasStarted) BOOL started;
- (id) initWithIp: (NSString *) theIp 
		   onPort: (int) thePort;

- (void) start;
- (void) handleReadFileDescriptors;
- (void) handleMessageFromClient: (int)descriptor;
- (void) handleClientConnect;

@end
