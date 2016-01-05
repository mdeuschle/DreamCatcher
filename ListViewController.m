//
//  ListViewController.m
//  DreamCatcher
//
//  Created by Matt Deuschle on 12/30/15.
//  Copyright © 2015 Matt Deuschle. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

// add tableview protocols so we have access to the methods
@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *titlesArray;
@property NSMutableArray *descriptionsArray;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // allocate and intialize array in memory
    self.titlesArray = [NSMutableArray new];
    self.descriptionsArray = [NSMutableArray new];

    // set editing to false, bc there is no way user can be editing app when view loads
    self.editing = false;
}

// allow user to move rows and manipulate array
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *titlesItem = [self.titlesArray objectAtIndex:sourceIndexPath.row];
    [self.titlesArray removeObject:titlesItem];
    [self.titlesArray insertObject:titlesItem atIndex:destinationIndexPath.row];

    NSString *descriptionItem = [self.descriptionsArray objectAtIndex:sourceIndexPath.row];
    [self.descriptionsArray removeObject:descriptionItem];
    [self.descriptionsArray insertObject:descriptionItem atIndex:destinationIndexPath.row];

    [self.tableView reloadData];
}

// helper method so user can enter dream
-(void)presentEntry;
{
    // create UI Alert object
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter New Dream" message:nil preferredStyle:UIAlertControllerStyleAlert];

    // add textflield to our newly created alert controller
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // code where user can edit textfield
        textField.placeholder = @"Dream Title";
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // code where user can edit textfield
        textField.placeholder = @"Dream Description";
    }];

    // add actions for alert contoller. First add cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    // now action for saving dream after user enters
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        // what happens when user selects save. We want to take text that user enters in textfield and add it to an array we can populate tableview cells with/
        // extract textfield from the UIAlert Controller. Get the first index (0) of Array
        UITextField *textFieldOne = alertController.textFields[0];

        // also for description field
        UITextField *textFieldTwo = alertController.textFields[1];

        // add text from textfield to titles arry
        [self.titlesArray addObject:textFieldOne.text];

        // add text from textfield to descriptions arry
        [self.descriptionsArray addObject:textFieldTwo.text];

        //reload the tableview after titles array is filled
        [self.tableView reloadData];
    }];

    // after saveAction is configured, add it to alert contorller
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];

    // present vc
    [self presentViewController:alertController animated:YES completion:nil];
}

// how many rows in tableView?
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // there will be as many tableview cells as there are dreams added
    return self.titlesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // assign text from array to cell
    cell.textLabel.text = [self.titlesArray objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender {
    [self presentEntry];
}
- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender {

    if (self.editing) {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    }
    else
    {
        self.editing = true;
        // program edit button to say "done" when tapped
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
    }
}

// pass dream description entered into the detail view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // create an instance of DetailViewController
    DetailViewController *dvc = segue.destinationViewController;

    // set properties of the dvc
    dvc.titleString = [self.titlesArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];

    dvc.descriptionString = [self.descriptionsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

// add function if user wants to slide left to delete dream
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.titlesArray removeObjectAtIndex:indexPath.row];
    [self.descriptionsArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
