//
//  ViewController.m
//  TwitterAPI
//
//  Created by Michail Kropivka on 20.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define INTERESTING_TAG_NAMES @"text", @"name", nil

@interface ViewController () {
    NSMutableData* tweetsData;
    
    NSMutableString *tweetsString;
    
	NSMutableDictionary *currentTweetDict;
	NSString *currentElementName;
	NSMutableString *currentText;
    //END:code.SimpleTwitterClientViewController.parsingheaders
	NSSet *interestingTags;
}

@end

@implementation ViewController
@synthesize getButton;
@synthesize textView;
@synthesize activityIndicator;


- (IBAction)updateTweets:(id)sender {
    textView.text = @"";
	tweetsData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/public_timeline.xml"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	[NSURLConnection connectionWithRequest:request delegate:self];
    
	[activityIndicator startAnimating];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[tweetsData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
	[errorAlert show];
}

//START:code.SimpleTwitterClientViewController.connectiondidfinishloading
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	[activityIndicator stopAnimating];
    
    textView.text = [[NSString alloc] initWithData:tweetsData encoding:NSUTF8StringEncoding];
	[self startParsingTweets];
}

#pragma mark - Parser

- (void) startParsingTweets {
    
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:tweetsData];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - NSXMLParserDelegate


- (void)parserDidStartDocument:(NSXMLParser *)parser {
	tweetsString = nil;
	tweetsString = [[NSMutableString alloc]
                    initWithCapacity: (20 * (140 + 20)) ];
	currentElementName = nil;
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
	if ([elementName isEqualToString:@"status"]) {
		currentTweetDict = nil;
		currentTweetDict = [[NSMutableDictionary alloc]
                            initWithCapacity: [interestingTags count]];
	}
	else if ([interestingTags containsObject: elementName]) { 
		currentElementName = elementName;
		currentText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:currentElementName]) {
		[currentTweetDict setValue: currentText forKey: currentElementName];
	} else if ([elementName isEqualToString:@"status"]) {
		[tweetsString appendFormat:@"%@: %@\n\n",
         [currentTweetDict valueForKey:@"name"],
         [currentTweetDict valueForKey:@"text"]];
	}
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentText appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	textView.text = tweetsString;
}

#pragma mark - View lifecycle

- (void) viewDidLoad {
	[super viewDidLoad];
	interestingTags = [[NSSet alloc] initWithObjects: INTERESTING_TAG_NAMES];
}

- (void)viewDidUnload
{
    [self setGetButton:nil];
    [self setTextView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
