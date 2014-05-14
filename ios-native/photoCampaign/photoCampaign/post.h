//
//  post.h
//  photoCampaign
//
//  Created by Dan Mindru on 13/05/14.
//  Copyright (c) 2014 Dan Mindru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface post : NSObject

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *campaignIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *photoURL;
@property (strong, nonatomic) NSString *created;
//user rating should be extended here

- (id)initWithId:(NSString *)_id andCampaignIdentifier:(NSString *)campaignIdentifier andTitle:(NSString *)title andDescription:(NSString *)description andPhotoURL:(NSString *)photoURL andCreated:(NSString *)created;

- (void) saveToPlist:(NSString *)plistURL;
+ (void) removeAllPosts:(NSString *)plistURL;
+ (NSMutableArray *)readFromPlist:(NSString *)plistURL;
+ (NSString *) getPlistURL;

@end
