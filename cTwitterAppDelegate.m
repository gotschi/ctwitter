//
//  XcodeAppDelegate.m
//  Xcode
//
//  Created by Manuel Gottstein on 08.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cTwitterAppDelegate.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation cTwitterAppDelegate

@synthesize window;

+(NSString *) ErrorDomain {
	return @"at.wizzart.cTwitter.ErrorDomain";
}

+(int) SocketFileDescriptionError { return 0; }
+(int) BindingSocketError { return 1; }

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	// Insert code here to initialize your application 
	serverStarted = false;
}

+ (NSDictionary *)dictionaryWithDescription: (NSString *)description
							  andSuggestion: (NSString *)suggestion
{
	NSArray *objArray;
	NSArray *keyArray;
	
	if(!suggestion) {
		objArray = [NSArray arrayWithObject: description];
		keyArray = [NSArray arrayWithObject: NSLocalizedDescriptionKey];
	} else {
		objArray = [NSArray arrayWithObjects: description, suggestion, nil];
		keyArray = [NSArray arrayWithObjects: NSLocalizedDescriptionKey, 
											  NSLocalizedRecoveryOptionsErrorKey, 
											  nil];
	}
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
	[dictionary retain];
	return dictionary;
}

- (Boolean)startServerWithIp: (NSString *)ip 
					  onPort:(NSString *)thePort 
				   withError:(NSError **)error 
{
	// get int value of port string - TODO: add validation?
	in_port_t port = [thePort intValue];
	
	int serverSocket, // socket file descriptor
	clientSocket, // client socket fd
	numberOfReceivedBytes,
	socketError;
	
	struct sockaddr_in serverAddress,
	clientAddress;
	
	char buffer[255],
	welcomeMessage[] = "Welcome to MMT!";
	
	Boolean handleError = false;
	// setup NSError for the case that something goes wrong
	NSString *errorDescription = nil;
	NSDictionary *errorUserDictionary = nil;
	int errorCode;
	if (error != NULL) { // only when caller specified an error pointer
		handleError = true;
	}
	// get new socket file descriptor for the server
	serverSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	// handle error
	if(serverSocket < 0) {
		NSLog(@"unknown error with socket description handler");
		return NO;
		/*
		if(handleError) {
			errorCode = [cTwitterAppDelegate SocketFileDescriptionError];
			int errorNumber = errno;
			errorUserDictionary = [cTwitterAppDelegate 
								   dictionaryWithDescription: @"Failed to start server"
								   andSuggestion: [NSString stringWithFormat: @"socket() ErrorNumber: %i", errorNumber]];
			*error = [ [[NSError alloc] 
						initWithDomain:[cTwitterAppDelegate ErrorDomain]
						code:errorCode 
						userInfo:errorUserDictionary] 
					  
					  autorelease];
			return NO;
		}
		 */
	}
	
	memset(&serverAddress, 0, sizeof(struct sockaddr_in));
	
	serverAddress.sin_family = AF_INET;
	serverAddress.sin_port = htons(port);
	
	const char* cString = [ip cStringUsingEncoding:NSASCIIStringEncoding]; 
	serverAddress.sin_addr.s_addr = inet_addr(cString);
	
	socketError = bind(serverSocket, (struct sockaddr *)&serverAddress, sizeof(struct sockaddr_in));
	if (socketError < 0) {
		NSLog(@"Error on binding socket %i", errno);
		return NO;
		
		if(handleError) {
			errorCode = [cTwitterAppDelegate BindingSocketError];
			errorUserDictionary = [cTwitterAppDelegate 
								   dictionaryWithDescription: @"Could not bind Socket" 
								   andSuggestion: @"please check the ip and port"];
			*error = [ [[NSError alloc] 
						initWithDomain:[cTwitterAppDelegate ErrorDomain]
						code:errorCode 
						userInfo:errorUserDictionary] 
					  
					  autorelease];
			return NO;
		}
	}
	
	socketError = listen(serverSocket, 3);
	if (socketError < 0) {
		NSLog(@"Error on listening");
	}
	
	socklen_t sizeOfClient = sizeof(clientAddress);
	NSLog(@"server listens for clients");
	while(true) {
		
		clientSocket = accept(serverSocket, (struct sockaddr *)&clientAddress, &sizeOfClient);
		if (clientSocket < 0) {
			NSLog(@"Error on accept");
		}
		
		NSLog(@"Client conntected");
		send(clientSocket, welcomeMessage, strlen(welcomeMessage), 0);
		
		while(true) {
			memset(buffer, 0, sizeof(buffer));
			numberOfReceivedBytes = recv(clientSocket, buffer, sizeof(buffer), 0);
			
			if (numberOfReceivedBytes < 0) {
				NSLog(@"Error on receive");
			}
			
			NSLog(@"Client sent: %@", 
				  [NSString stringWithCString: buffer length:strlen(buffer)]);
			
			send(clientSocket, buffer, strlen(buffer), 0);
			
			if (strlen(buffer) == 1 && buffer[0] == 'e') {
				NSLog(@"Client disconnected");
				
				close(clientSocket);
				
				break;
			}
		}
	}
	
	close(serverSocket);
}

- (void)startServer: (id)sender 
{
	if(!serverStarted) {
		NSString *ipString = [serverIp stringValue];
		NSString *portString = [serverPort stringValue];
		NSLog(@"ip: %@, port: %@", ipString, portString);
		
		NSError *bindError = nil;
		Boolean success = [self startServerWithIp: ipString 
										onPort: portString 
									 withError: &bindError];
		
		/*
		if(!success) {
			NSAlert *bindAlert = [NSAlert alertWithError:bindError];
			[bindAlert runModal]; // Ignore return value.
			return;
		}
		*/
	}
	//serverStarted = true;
}

@end
