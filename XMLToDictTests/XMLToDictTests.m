//
//  XMLToDictTests.m
//  XMLToDictTests
//
//  Created by Jonathan Lozinski on 18/10/2013.
//  Copyright (c) 2013 Jonathan Lozinski. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMLToDict.h"

@interface XMLToDictTests : XCTestCase

@end

@implementation XMLToDictTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNodeMapstoItsText
{
    NSString *xml = @"<node>the text</node>";
    NSData *data = [xml dataUsingEncoding:NSUTF16StringEncoding];
    NSDictionary *result = [XMLToDict dictFromData:data];
    
    XCTAssertEqualObjects(
                          @"the text",
                          [result objectForKey:@"node"],
                          @"Expected text for node key");
}

-(void)testNodeMapsMultilineText
{
    NSString *xml = @"<multiline>this text\nhas lines</multiline>";
    NSData *data = [xml dataUsingEncoding:NSUTF16StringEncoding];
    NSDictionary *result = [XMLToDict dictFromData:data];
    
    XCTAssertEqualObjects(
                          @"this text\nhas lines",
                          [result objectForKey:@"multiline"],
                          @"Expected multiline");
}

-(void)testNestsNodesUnderElement
{
    NSString *xml = @"<node><child>text</child></node>";
    NSData *data = [xml dataUsingEncoding:NSUTF16StringEncoding];
    NSDictionary *result = [XMLToDict dictFromData:data];
    
    NSDictionary *node = [result objectForKey:@"node"];
    XCTAssertEqualObjects(
                          @"text",
                          [node objectForKey:@"child"],
                          @"Expected nested child text");
}

-(void)testCreatesArrayOfRepeatedNodes
{
    NSString *xml = @"<node><child>one</child><child>two</child><child>three</child></node>";
    NSData *data = [xml dataUsingEncoding:NSUTF16StringEncoding];
    NSDictionary *result = [XMLToDict dictFromData:data];
    
    NSDictionary *node = [result objectForKey:@"node"];
    NSArray *children = [node objectForKey:@"child"];
    NSLog(@"Node: %@", result);
    XCTAssertEqualObjects(
                          @"one",
                          children[0],
                          @"Expected item one");
    XCTAssertEqualObjects(
                          @"two",
                          children[1],
                          @"Expected item two");
    XCTAssertEqualObjects(
                          @"three",
                          children[2],
                          @"Expected item three");
}

@end
