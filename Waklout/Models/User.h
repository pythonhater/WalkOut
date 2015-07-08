//
//  User.h
//  Waklout
//
//  Created by yoho on 15/7/8.
//  Copyright (c) 2015年 janlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;

@end
