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
    //Element collides with previously Parsed
    if(item) {
        if ([item isKindOfClass:[NSMutableArray class]]) {
            //We already know this is a collection, just add it
            NSMutableArray *items = item;
            [items addObject:child];
        } else {
            //Replace existing will a collection of it and the new one
            NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[item, child]];
            [current setObject:items forKey:elementName];
        }
    } else {
        //New node
        [current setObject:child forKey:elementName];
    }
    //New node is current stack item
    [self.stack addObject:child];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.text appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                     namespaceURI:(NSString *)namespaceURI
                                    qualifiedName:(NSString *)qName {

    //Pop item being parsed off the stack
    id child = [self.stack lastObject];
    [self.stack removeLastObject];
    
    //Check to see how to close off this node (if there's text)
    NSMutableDictionary *parent = [self.stack lastObject];
    id item = [parent objectForKey:elementName];
    if ([child count] == 0) {
        //Just a TEXT node
        
        if ([item isKindOfClass:[NSMutableArray class]]) {
            // Replace item in collection
            NSMutableArray *items = (NSMutableArray *)item;
            NSUInteger childLocation = [items indexOfObject:child];
            [items setObject:self.text atIndexedSubscript:childLocation];
        } else {
            // Replace item in parent
            [parent setObject:self.text forKey:elementName];
        }
    }

}

@end
