//
//  PickerViewLabel.m
//  DatePickerLibrary
//
//  Created by Zhangjingshun on 11-6-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerViewLabel.h"


@implementation PickerViewLabel
- (void)didMoveToSuperview
{
	if ([[self superview] respondsToSelector:@selector(setShowSelection:)])
	{
		[[self superview] performSelector:@selector(setShowSelection:) withObject:NO];
	}
}
@end
