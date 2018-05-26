//
//  Unrar4iOS2.h
//  Unrar4iOS
//
//  Created by Rogerio Pereira Araujo on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Unrar4iOS/raros.hpp>
#import <Unrar4iOS/dll.hpp>

@interface Unrar4iOS2 : NSObject {
	HANDLE	 _rarFile;
	struct	 RARHeaderDataEx *header;
	struct	 RAROpenArchiveDataEx *flags;
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *password;

- (BOOL)unrarOpenFile:(NSString *)rarFile;
- (BOOL)unrarOpenFile:(NSString *)rarFile withPassword:(NSString *)aPassword;
- (NSArray *)unrarListFiles;
- (BOOL)unrarFileTo:(NSString *)path overWrite:(BOOL)overwrite;
- (NSData *)extractStream:(NSString *)aFile;
- (BOOL)unrarCloseFile;

@end
