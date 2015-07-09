//
//  WK_HomeViewController.m
//  Waklout
//
//  Created by yoho on 15/7/7.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import "WK_HomeViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface WK_HomeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UITextField *sexTextField;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation WK_HomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"HOME", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    [self followScrollView:self.view];
    
}

- (IBAction)addIntoDataSource:(id)sender
{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [user setName:self.nameTextField.text];
    [user setAge:@([self.ageTextField.text integerValue])];
    [user setSex:self.sexTextField.text];
    NSError *error;
    BOOL isSaveSuccess = [self.appDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"error %@",error);
    } else {
        NSLog(@"save successful");
    }
    
}

- (IBAction)query:(id)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:user];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error:%@",error);
    }
    
    for (User* user in mutableFetchResult) {
        NSLog(@"name:%@----age:%@------sex:%@",user.name,user.age,user.sex);
    }
}

- (IBAction)update:(id)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *user = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:user];
    
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",self.nameTextField.text];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResult = [[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //更新age后要进行保存，否则没更新
    for (User* user in mutableFetchResult) {
        [user setAge:@([self.ageTextField.text integerValue])];
    }
    
    if ([self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

- (IBAction)delete:(id)sender
{
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:user];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"name == %@",self.nameTextField.text];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error:%@",error);
    }
    for (User *user in mutableFetchResult) {
        [self.appDelegate.managedObjectContext deleteObject:user];
    }
    
    if ([self.appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
