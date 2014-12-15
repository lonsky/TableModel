//
//  IMPTableModel.m
//  IM Plus
//
//  Created by Alexandr Zagorsky on 23.09.10.
//  Copyright 2010 SHAPE services. All rights reserved.
//

#import "IMPTableModel.h"

@implementation IMPTableModel

-(NSIndexPath*)indexPathForCellWithId:(NSInteger)cellId
{
	NSIndexPath* result = nil;
	
	if (cellsModel != nil)
	{
		NSNumber* cellIdNum  = [[NSNumber alloc] initWithInt:cellId];
		if (cellIdNum == nil)
			return result;
				
		for (NSNumber* key in [cellsModel keyEnumerator])
		{
			NSArray* cellsArray = [cellsModel objectForKey:key];
			
			NSInteger index = [cellsArray indexOfObject:cellIdNum];
			if (index != NSNotFound)
			{
				result = [NSIndexPath indexPathForRow:index inSection:[sectionsModel indexOfObject:key]];
				
				break;
			}
		}
		
		[cellIdNum release];
	}	
	
	return result;
}

-(NSInteger)indexForSectionId:(NSInteger)sectionId
{
	NSInteger res = NSNotFound;
	
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];	
	if (sectionsModel != nil && [sectionsModel count] > 0 && sectionIdNum != nil)
		res = [sectionsModel indexOfObject:sectionIdNum];
	
	[sectionIdNum release];
	
	return res;
}

#pragma mark - Model info messages

-(NSInteger)numberOfSections
{
	return [sectionsModel count];
}

-(NSInteger)numberOfRowsInSectionWithId:(NSInteger)sectionId
{
	NSNumber* keyNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (keyNum == nil)
		return 0;
		
	NSArray* sectionCells = [cellsModel objectForKey:keyNum];
	[keyNum release];
	
	if (deleteQuery != nil && [deleteQuery count] > 0)
	{
		isFlushing = YES;
		
		for (NSIndexPath* cellPath in deleteQuery)
			[self removeCellWithId:cellPath.row fromSectionWithId:cellPath.section];
		
		isFlushing = NO;
		[deleteQuery release];
		deleteQuery = nil;
	}
	
	return [sectionCells count];
}

-(NSInteger)numberOfRowsInSectionWithIndex:(NSInteger)sectionIndex
{
	return [self numberOfRowsInSectionWithId:[self sectionIdForIndex:sectionIndex]];
}

#pragma mark - Model accessing messages

-(NSInteger)sectionIdForIndex:(NSInteger)index
{
	return [[sectionsModel objectAtIndex:index] intValue];
}

-(NSInteger)sectionIdForIndexPath:(NSIndexPath*)indexPath
{
	return [self sectionIdForIndex:indexPath.section];
}

-(NSInteger)cellIdForIndexPath:(NSIndexPath*)indexPath
{
	NSNumber* keyNum  = [sectionsModel objectAtIndex:indexPath.section];
	if (keyNum == nil)
		return 0;
	
	NSArray* sectionCells = [cellsModel objectForKey:keyNum];
	
	return [[sectionCells objectAtIndex:indexPath.row] intValue];
}

#pragma mark - Sections operation messages

-(NSInteger)addSectionWithId:(NSInteger)sectionId
{		
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (sectionIdNum == nil)
		return NSNotFound;
	
	if (sectionsModel == nil)
		sectionsModel = [[NSMutableArray alloc] init];
	
	NSInteger index = [sectionsModel indexOfObject:sectionIdNum];
	if (index == NSNotFound)
	{
		[sectionsModel addObject:sectionIdNum];
		index = [sectionsModel count] - 1;		
	}
	
	[sectionIdNum release];
	
	return index;
}

-(NSInteger)insertSectionWithId:(NSInteger)sectionId atIndex:(NSInteger)index
{		
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (sectionIdNum == nil)
		return NSNotFound;
	
	if (sectionsModel != nil)
		if (index < [sectionsModel count])
			if ([sectionsModel indexOfObject:sectionIdNum] == NSNotFound)
				[sectionsModel insertObject:sectionIdNum atIndex:index];
	
	[sectionIdNum release];
	
	return index;
}

-(void)removeSectionWithId:(NSInteger)sectionId
{	
	if (sectionsModel == nil || [sectionsModel count] == 0)
		return;
	
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (sectionIdNum == nil)
		return;
	
	[sectionsModel removeObject:sectionIdNum];
	[cellsModel removeObjectForKey:sectionIdNum];
		
	[sectionIdNum release];
}

#pragma mark - Cells operation messages

-(NSIndexPath*)addCellWithId:(NSInteger)cellId toSectionWithId:(NSInteger)sectionId
{		
	NSIndexPath* result = nil;
	NSNumber* cellIdNum  = [[NSNumber alloc] initWithInt:cellId];	
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];	
	if (sectionIdNum == nil || cellIdNum == nil)
	{
		[cellIdNum release];
		[sectionIdNum release];
		return result;
	}
	
	//????? shuld we add section automaticly or just return?
	if (sectionsModel == nil || [sectionsModel indexOfObject:sectionIdNum] == NSNotFound)	
		[self addSectionWithId:sectionId];
	
	if (cellsModel == nil)
		cellsModel = [[NSMutableDictionary alloc] init];
	
	NSMutableArray* cellsArray = [cellsModel objectForKey:sectionIdNum];
	if (cellsArray == nil) 
	{
		cellsArray = [[NSMutableArray alloc] init];
		
		[cellsArray addObject:cellIdNum];
		
		[cellsModel setObject:cellsArray forKey:sectionIdNum];
		[cellsArray release];
	}
	else if ([cellsArray indexOfObject:cellIdNum] == NSNotFound)
	{
		[cellsArray addObject:cellIdNum];
	}
	
	[cellIdNum release];
	[sectionIdNum release];
	
	result = [self indexPathForCellWithId:cellId];
	
	return result;
}

-(NSIndexPath*)insertCellWithId:(NSInteger)cellId toSectionWithId:(NSInteger)sectionId atIndex:(NSInteger)index
{	
	NSIndexPath* result = nil;
	NSNumber* cellIdNum  = [[NSNumber alloc] initWithInt:cellId];	
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (sectionIdNum == nil || cellIdNum == nil)
	{
		[cellIdNum release];
		[sectionIdNum release];
		
		return result;
	}
	
	if (cellsModel != nil && [cellsModel count] > 0)
	{		
		NSMutableArray* cellsArray = [cellsModel objectForKey:sectionIdNum];
	
		if (cellsArray != nil)
		{
			if (index < [cellsArray count])
			{
				if ([cellsArray indexOfObject:cellIdNum] == NSNotFound)//Only unique items allowed
				{
					[cellsArray insertObject:cellIdNum atIndex:index];
					
					result = [self indexPathForCellWithId:cellId];
				}
			}
			else
			{
				result = [self addCellWithId:cellId toSectionWithId:sectionId];
			}
		}				
	}
	
	[cellIdNum release];
	[sectionIdNum release];
	
	return result;
}

-(NSIndexPath*)removeCellWithId:(NSInteger)cellId fromSectionWithId:(NSInteger)sectionId
{	
	NSIndexPath* result = nil;
	
	NSNumber* cellIdNum  = [[NSNumber alloc] initWithInt:cellId];
	NSNumber* sectionIdNum  = [[NSNumber alloc] initWithInt:sectionId];
	if (sectionIdNum == nil || cellIdNum == nil)
	{
		[cellIdNum release];
		[sectionIdNum release];
		
		return result;
	}
		
	if (cellsModel != nil && [cellsModel count] > 0)
	{
		NSMutableArray* cellsArray = [cellsModel objectForKey:sectionIdNum];
		if (cellsArray != nil)
		{
			result = [self indexPathForCellWithId:cellId];
			if (isFlushing)
			{
				[cellsArray removeObject:cellIdNum];
			}
			else if (result != nil)
			{
				if (deleteQuery == nil)
					deleteQuery = [[NSMutableArray alloc] init];
				[deleteQuery addObject:[NSIndexPath indexPathForRow:cellId inSection:sectionId]];
			}
		}
	}
		
	[cellIdNum release];
	[sectionIdNum release];
	
	return result;
}

-(void)removeCellAtIndexPath:(NSIndexPath*)indexPath
{
	NSInteger cellId = [self cellIdForIndexPath:indexPath];
	NSInteger sectionId = [self sectionIdForIndexPath:indexPath];
	
	[self removeCellWithId:cellId fromSectionWithId:sectionId];
}

-(void)moveCellWithIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	NSInteger cellId = [self cellIdForIndexPath:fromIndexPath];
	
	isFlushing = YES;
	[self removeCellAtIndexPath:fromIndexPath];
	isFlushing = NO;
	
	NSInteger newSectionId = [self sectionIdForIndexPath:toIndexPath];
	NSInteger index = toIndexPath.row;
	[self insertCellWithId:cellId toSectionWithId:newSectionId atIndex:index];
}

#pragma mark - Model clearing messages

-(void)removeSectionsModel
{
	[sectionsModel removeAllObjects];
	
	[deleteQuery release];
	deleteQuery = nil;
}

-(void)removeCellsModel
{
	[cellsModel removeAllObjects];
	
	[deleteQuery release];
	deleteQuery = nil;
}

-(void)removeModel
{
	[self removeSectionsModel];
	[self removeCellsModel];
}

#pragma mark - Memory managment

-(void)dealloc
{
	[cellsModel release];	
	[sectionsModel release];
	[deleteQuery release];
	
	[super dealloc];
}

#pragma mark - Description

-(NSString*) description
{
    return [NSString stringWithFormat:@"%@. %@.", [super description], cellsModel];
}

@end
