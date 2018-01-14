//
//  ZDStudent.h
//  DZ 31-32 - Obj_UITableView_Editinf_Cucto
//
//  Created by mac on 14.01.18.
//  Copyright © 2018 Dima Zgera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZDStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat averageGrade;

+ (ZDStudent*) randomStudent;


@end
