//
//  DetailViewController.m
//  Presidents
//
//  Created by Michail Kropivka on 28.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Presidents.h"

@interface DetailViewController () <UITextFieldDelegate>
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

@synthesize president;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize currentTextField;

@synthesize myParent;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"Name:", @"From:",
                      @"To:", @"Party:", nil]; 
    self.fieldLabels = array;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStyleDone 
                                                                  target:self 
                                                                  action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init]; 
    self.tempValues = dict;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    if (currentTextField != nil) {
        NSNumber *tagAsNum = [NSNumber numberWithInt:currentTextField.tag]; 
        [tempValues setObject:currentTextField.text forKey:tagAsNum];
    }
    for (NSNumber *key in [tempValues allKeys]) 
    {
        switch ([key intValue]) { 
            case kNameRowIndex:
                president.name = [tempValues objectForKey:key];
                break; 
            case kFromYearRowIndex:
                president.fromYear = [tempValues objectForKey:key];
                break; 
            case kToYearRowIndex:
                president.toYear = [tempValues objectForKey:key];
                break; 
            case kPartyIndex:
                president.party = [tempValues objectForKey:key]; 
            default:
                break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    [myParent.tableView reloadData];
}

- (IBAction)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
}

#pragma mark - #pragma mark Table Data Source Methods 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return kNumberOfEditableRows;
}
		
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PresidentCellIdentifier = @"PresidentCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PresidentCellIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:PresidentCellIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, 75, 25)];
        
        label.textAlignment = UITextAlignmentRight; 
        label.tag = kLabelTag; 
        label.font = [UIFont boldSystemFontOfSize:14]; 
        [cell.contentView addSubview:label];
        UITextField *textField = [[UITextField alloc] initWithFrame: CGRectMake(90, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO; 
        [textField setDelegate:self]; 
        textField.returnKeyType = UIReturnKeyDone; 
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField]; 
    }
    
    NSUInteger row = [indexPath row];

    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag]; 
    UITextField *textField = nil; 
    for (UIView *oneView in cell.contentView.subviews)
    if ([oneView isMemberOfClass:[UITextField class]]) 
        textField = (UITextField *)oneView;
    
    
    label.text = [fieldLabels objectAtIndex:row]; 
    NSNumber *rowAsNum = [NSNumber numberWithInt:row]; 
    switch (row) {
        case kNameRowIndex: 
            if ([[tempValues allKeys] containsObject:rowAsNum])
                textField.text = [tempValues objectForKey:rowAsNum];
            else
                textField.text = president.name; 
        break;
        case kFromYearRowIndex: 
            if ([[tempValues allKeys] containsObject:rowAsNum])
                textField.text = [tempValues objectForKey:rowAsNum];
            else
                textField.text = president.fromYear; 
        break;
        case kToYearRowIndex: 
            if ([[tempValues allKeys] containsObject:rowAsNum])
            textField.text = [tempValues objectForKey:rowAsNum];
        else
            textField.text = president.toYear; 
            break;
        case kPartyIndex: 
            if ([[tempValues allKeys] containsObject:rowAsNum])
            textField.text = [tempValues objectForKey:rowAsNum];
        else
            textField.text = president.party; 
        default:
            break;
            
    } 
    if( currentTextField == textField )
        currentTextField = nil;
    
    textField.tag = row; 
    return cell;
}
#pragma mark - #pragma mark Table Delegate Methods 
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark Text Field Delegate Methods 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField { 
    NSNumber *tagAsNum = [NSNumber numberWithInt:textField.tag]; 
    [tempValues setObject:textField.text forKey:tagAsNum];
}

@end
