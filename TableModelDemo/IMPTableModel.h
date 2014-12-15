//
//  IMPTableModel.h
//  IM Plus
//
//  Created by Alexandr Zagorsky on 23.09.10.
//  Copyright 2010 SHAPE services. All rights reserved.
//

/*
Table model implementation.
Model consisting of cells ID and sections ID.
*/
@interface IMPTableModel : NSObject 
{
	NSMutableDictionary* cellsModel;
	NSMutableArray* sectionsModel;
	
	BOOL isFlushing;
	NSMutableArray* deleteQuery;
}

//Model info messages
//-(NSInteger)numberOfSections;//Returns number of sections currently stored in model
//-(NSInteger)numberOfRowsInSectionWithId:(NSInteger)sectionId;//Returns number of cells in section with specified ID currently stored in model
//-(NSInteger)numberOfRowsInSectionWithIndex:(NSInteger)sectionIndex;

//Model accessing messages
//-(NSInteger)sectionIdForIndex:(NSInteger)index;//Returns section Id for given index
//-(NSInteger)sectionIdForIndexPath:(NSIndexPath*)indexPath;//Returns section Id for given indexPath
//-(NSInteger)indexForSectionId:(NSInteger)sectionId;

//-(NSInteger)cellIdForIndexPath:(NSIndexPath*)indexPath;//Returns cell Id for given indexPath
//-(NSIndexPath*)indexPathForCellWithId:(NSInteger)cellId;

//Sections operation messages
//-(NSInteger)addSectionWithId:(NSInteger)sectionId;
//-(NSInteger)insertSectionWithId:(NSInteger)sectionId atIndex:(NSInteger)index;
//-(void)removeSectionWithId:(NSInteger)sectionId;

//Cells operation messages
//-(NSIndexPath*)addCellWithId:(NSInteger)cellId toSectionWithId:(NSInteger)sectionId;

//-(NSIndexPath*)insertCellWithId:(NSInteger)cellId toSectionWithId:(NSInteger)sectionId atIndex:(NSInteger)index;
//-(NSIndexPath*)removeCellWithId:(NSInteger)cellId fromSectionWithId:(NSInteger)sectionId;
//-(void)removeCellAtIndexPath:(NSIndexPath*)indexPath;

-(void)moveCellWithIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

//Model cleaning messages
//-(void)removeModel;//Clears model

@end
