//
//  ViewController.m
//  DZ 31-32 - Obj_UITableView_Editinf_Cucto
//
//  Created by mac on 14.01.18.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import "ViewController.h"
#import "ZDGroup.h"
#import "ZDStudent.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* groups;

@end

@implementation ViewController

- (void) loadView {
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createGroupsAndStudents];
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditButton:)];
    
    [self.navigationItem setRightBarButtonItem:editButton];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAddButton:)];
    
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    self.tableView.allowsSelectionDuringEditing = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) actionEditButton:(UIBarButtonItem*)sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item target:self action:@selector(actionEditButton:)];
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}

- (void) actionAddButton:(UIBarButtonItem*) sender {
    
    ZDGroup *group = [[ZDGroup alloc]init];
    group.name = [NSString stringWithFormat:@"Group #%ld", [self.groups count] + 1];
    group.students = @[[ZDStudent randomStudent], [ZDStudent randomStudent]];
    
    [self.groups insertObject:group atIndex:0];
    
    NSInteger newSectionIndex = 0;
    
    [self.tableView beginUpdates];
    
    NSIndexSet *insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
    
    [self.tableView insertSections:insertSections withRowAnimation:[self.groups count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication]isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }
    });
    
}

#pragma mark - Data for UITableView

- (void) createGroupsAndStudents {
    
    self.groups = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < arc4random_uniform(6) + 5; i ++) {
        
        ZDGroup *group = [[ZDGroup alloc]init];
        
        group.name = [NSString stringWithFormat:@"Group #%d",i];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < arc4random_uniform(11) + 5; j++) {
            
            [tempArray addObject:[ZDStudent randomStudent]];
            
        }
        
        group.students = tempArray;
        [self.groups addObject:group];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZDGroup *group = [self.groups objectAtIndex:section];
    
    return [group.students count] + 1;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groups objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *studentIdentifier = @"studentIdentifier";
    
    static NSString *addStudentIdentifier = @"addStudentIdentifier";
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.text = @"Add New student";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.font = [UIFont fontWithName:@"Optima-Bold" size:18.f];
        }
        
        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
        }
        
        ZDGroup *group = [self.groups objectAtIndex:indexPath.section];
        ZDStudent *student = [group.students objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.averageGrade];
        cell.textLabel.font = [UIFont fontWithName:@"Optima-Regular" size:18.f];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Optima-Regular" size:18.f];
        
        if (student.averageGrade > 4.f) {
            cell.detailTextLabel.textColor = [UIColor greenColor];
            
        } else if (student.averageGrade > 3.f) {
            cell.detailTextLabel.textColor = [UIColor orangeColor];
            
        } else {
            
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        return cell;
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ZDGroup *sourceGroup = [self.groups objectAtIndex:sourceIndexPath.section];
    ZDStudent *student = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        sourceGroup.students = tempArray;
        
    } else {
        
        [tempArray removeObject:student];
        sourceGroup.students = tempArray;
        
        ZDGroup *destinationGroup = [self.groups objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:student atIndex:destinationIndexPath.row - 1];
        destinationGroup.students = tempArray;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ZDGroup *sourceGroup = [self.groups objectAtIndex:indexPath.section];
        ZDStudent *student = [sourceGroup.students objectAtIndex:indexPath.row - 1];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
        [tempArray removeObject:student];
        sourceGroup.students = tempArray;
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    
    if (indexPath.row == 0 && editingStyle == UITableViewCellEditingStyleInsert) {
        
        ZDGroup *group = [self.groups objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = nil;
        
        if (group.students) {
            tempArray = [NSMutableArray arrayWithArray:group.students];
        }
        
        NSInteger newStudentIndex = 0;
        
        [tempArray insertObject:[ZDStudent randomStudent] atIndex:newStudentIndex];
        group.students = tempArray;
        
        
        [tableView beginUpdates];
        NSIndexPath *newIndexpath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexpath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //нет слева красного шарика при загрузке
    return indexPath.row == 0 ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        
        return proposedDestinationIndexPath;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        ZDGroup *group = [self.groups objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = nil;
        
        if (group.students) {
            
            tempArray = [NSMutableArray arrayWithArray:group.students];
        }
        
        NSInteger newStudentIndex = 0;
        
        [tempArray insertObject:[ZDStudent randomStudent] atIndex:newStudentIndex];
        group.students = tempArray;
        
        
        [self.tableView beginUpdates];
        NSIndexPath *updadatingIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[updadatingIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication]  beginIgnoringInteractionEvents];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    }
}



@end
