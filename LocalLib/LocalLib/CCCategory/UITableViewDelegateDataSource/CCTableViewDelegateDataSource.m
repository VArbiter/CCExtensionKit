//
//  CCTableViewDelegateDataSource.m
//  CCLocalLibrary
//
//  Created by 冯明庆 on 2017/4/22.
//  Copyright © 2017年 冯明庆. All rights reserved.
//

#import "CCTableViewDelegateDataSource.h"
#import "CCCommonDefine.h"

@interface CCTableViewDelegate ()

@end

@implementation CCTableViewDelegate

- (id < UITableViewDelegate >) initWithDefaultSettings {
    if ((self = [super init])) {
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.blockCellHeight ? self.blockCellHeight(tableView , indexPath) : 45.f ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeaderHeight ? self.blockSectionHeaderHeight(tableView , section) : .0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.blockSectionHeader ? self.blockSectionHeader(tableView , section) : nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidSelect) {
        if (self.blockDidSelect(tableView , indexPath)) {
            [tableView deselectRowAtIndexPath:indexPath animated:false];
        }
    }
}

_CC_DETECT_DEALLOC_

@end

#pragma mark - -----------------------------------------------------------------

@interface CCTableViewDataSource ()

@end

@implementation CCTableViewDataSource

- (id < UITableViewDataSource >) initWithDefaultSettings {
    if ((self = [super init])) {
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.blockSections ? self.blockSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blockRowsInSections ? self.blockRowsInSections(tableView , section) : 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringCellIdentifer = self.blockCellIdentifier ? self.blockCellIdentifier(tableView , indexPath) : @"CELL";
    
    UITableViewCell *cell = nil;
    if (self.blockCellIdentifier) {
        cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer
                                               forIndexPath:indexPath];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:stringCellIdentifer];
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:stringCellIdentifer];
    }
    
    return self.blockConfigCell ? self.blockConfigCell(tableView , cell , indexPath) : cell;
}

_CC_DETECT_DEALLOC_

@end
