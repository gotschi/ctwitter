//
//  Server.m
//  cTwitterServer
//
//  Created by Dominik Guzei on 29.11.10.
//  Copyright 2010 Fh Salzburg. All rights reserved.
//

#import "Server.h"
#include <sys/select.h>

@implementation Server

@synthesize started;
@synthesize connected;

- (id) initWithIp: (NSString *) theIp 
		   onPort: (int) thePort
{
	ip = theIp;
	port = thePort;
	
	// BUILD SERVER ADDRESS
	
	// override serverAddress with zeroes
	memset(&serverAddress, 0, sizeof(struct sockaddr_in));
	
	// build serverAddress
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons(port);
	
	// convert ip string from textfield to an ascii c string
	const char* cStringIp = [ip cStringUsingEncoding:NSASCIIStringEncoding]; 
	serverAddress.sin_addr.s_addr = inet_addr(cStringIp);
	
	connected = false;
	
	// OPEN
	serverSocketFileDescriptor = socket(PF_INET, SOCK_STREAM, 0);
	if (serverSocketFileDescriptor < 0) {
        // TODO: generate error
		NSLog(@"Error on opening socket");
		return nil;
    }
	
	// BIND
	int bindResult = bind(serverSocketFileDescriptor, (struct sockaddr *)&serverAddress, sizeof(serverAddress));
    if (bindResult < 0) {
		// TODO: generate error
		NSLog(@"Error on binding");
        return nil;
    }
	
	// LISTEN
	int listenResult = listen(serverSocketFileDescriptor, 3);
    if (listenResult < 0) {
        // TODO: generate error
		NSLog(@"Error on listening");
        return nil;
    }
	
	highestSocketFileDescriptor = serverSocketFileDescriptor;
	connected = true;
	return self;
}

- (void) start
{
	
	// empty our main set
	FD_ZERO(&mainReadSet);
	// set bit for server socket descriptor
	FD_SET(serverSocketFileDescriptor, &mainReadSet);
	
	while (connected) {
		
		// copy the master set to the current set for this loop
		memcpy(&currentReadSet, &mainReadSet, sizeof(mainReadSet));
		
		// get any file descriptors that are ready to be read
        int selectResult = select(highestSocketFileDescriptor + 1, &currentReadSet, NULL, NULL, NULL);
		
		// HANDLE SELECT ERRORs
		if(selectResult == -1) {
			switch (errno) {
				case EBADF:
					NSLog(@"Invalid file descriptor in current set");
					break;
				case EINTR:
					NSLog(@"A signal interrupted the call or the time limit expired.");
					break;
				default:
					NSLog(@"Problem with select occured");
			}
            close(serverSocketFileDescriptor);
		}
		
		// HANDLE ANY FILE DESCRIPTORS THAT ARE READY
		if(selectResult > 0) {
			[self handleReadFileDescriptors];
		}
	}
}

- (void) handleReadFileDescriptors
{
	// loop through all socket file descriptors
	for(int descriptor = 0; descriptor < highestSocketFileDescriptor + 1; descriptor++) {
		
		// here is something to read
		if(FD_ISSET(descriptor, &currentReadSet)) {
			
			if(descriptor != serverSocketFileDescriptor) {
				// messages
				[self handleMessageFromClient: descriptor];
				
			} else {
				// connects
				[self handleClientConnect];
			}
		}
	}
}

- (void) handleMessageFromClient:(int)descriptor 
{
	
}

- (void) handleClientConnect
{
	int clientConnect;
	// accept new client
	clientConnect = accept(serverSocketFileDescriptor, 
						   (struct sockaddr *)&clientAddress, 
						   (socklen_t *) sizeof(clientAddress));
	
	// add client to main set
	FD_SET(clientConnect, &mainReadSet);
	
	// set new client as highest socket file descriptor
	if (clientConnect > highestSocketFileDescriptor) {
		highestSocketFileDescriptor = clientConnect;
	}
	
	NSLog(@"CONNECTION: Client connected on %i", clientConnect);
}

@end
