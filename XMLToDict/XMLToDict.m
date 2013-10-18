//
//  XMLToDict.m
//  XMLToDict
//
//  Created by Jonathan Lozinski on 18/10/2013.
//  Copyright (c) 2013 Jonathan Lozinski. All rights reserved.
//

#import "XMLToDict.h"

@interface XMLToDict ()
@property(nonatomic, strong)NSMutableArray *stack;
@property(nonatomic, strong)NSMutableString *text;
@end

@implementation XMLToDict

+(NSDictionary *)dictFromData:(NSData *)data {
    NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    XMLToDict *converter = [[XMLToDict alloc] initWithRoot:root];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:converter];
    [parser parse];
    return [root copy];
}

-(XMLToDict *)initWithRoot:(NSMutableDictionary *)root {
    self = [self init];
    _stack = [[NSMutableArray alloc] initWithArray:@[root]];
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                       namespaceURI:(NSString *)namespaceURI
                                      qualifiedName:(NSString *)qName
                                         attributes:(NSDictionary *)attributeDict {
    self.text = [[NSMutableString alloc] init];
    NSMutableDictionary *current = [self.stack lastObject];
    NSMutableDictionary *child = [[NSMutableDictionary alloc] init];
    id item = [current objectForKey:elementName];
    if(item) {
        NSLog(@"Duplicate Item: %@ in %@", elementName, current);
        if ([item isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *items = item;
            [items addObject:child];
        } else {
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[item, child]];
            [current setObject:items forKey:elementName];
        }
    } else {
        [current setObject:child forKey:elementName];
    }
    [self.stack addObject:child];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.text appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                     namespaceURI:(NSString *)namespaceURI
                                    qualifiedName:(NSString *)qName {

    id child = [self.stack lastObject];
    [self.stack removeLastObject];
    NSMutableDictionary *parent = [self.stack lastObject];
    
    if([child isKindOfClass:[NSMutableDictionary class]]) {
        if ([child count] == 0) {
            [parent setObject:self.text forKey:elementName];
        }
    }
}

@end
