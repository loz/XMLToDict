//
//  XMLToDict.h
//  XMLToDict
//
//  Created by Jonathan Lozinski on 18/10/2013.
//  Copyright (c) 2013 Jonathan Lozinski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLToDict : NSObject <NSXMLParserDelegate>

-(XMLToDict *)initWithRoot:(NSMutableDictionary *)root;

+(NSDictionary *)dictFromData:(NSData *)data;

@end
