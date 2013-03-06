//
//  PMPlayer.h
//  Pong Madness
//
//  Created by Ludovic Landry on 2/27/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PMParticipant.h"

@class PMLeaderboardPlayer, PMTeam, PMTournament, PMLeaderboard;

typedef enum {
	PMPlayerHandednessLefty = 0,
	PMPlayerHandednessRighty
} PMPlayerHandedness;

@interface PMPlayer : PMParticipant

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *handedness;
@property (nonatomic, strong) NSSet *leaderboardPlayerSet;
@property (nonatomic, strong) NSSet *teamSet;
@property (nonatomic, strong) NSDate *sinceDate;
@property (nonatomic, strong) NSSet *tournamentSet;
@property (nonatomic, strong) NSNumber *active;

+ (PMPlayer *)playerWithUsername:(NSString *)username;

- (PMLeaderboardPlayer *)leaderboardPlayerInLeaderboard:(PMLeaderboard *)leaderboard;
- (NSNumber *)rankInLeaderboard:(PMLeaderboard *)leaderboard;

- (NSNumber *)timePlayed;
- (void)descativate;

@end

@interface PMPlayer (CoreDataGeneratedAccessors)

- (void)addLeaderboardPlayerSetObject:(PMLeaderboardPlayer *)value;
- (void)removeLeaderboardPlayerSetObject:(PMLeaderboardPlayer *)value;
- (void)addLeaderboardPlayerSet:(NSSet *)values;
- (void)removeLeaderboardPlayerSet:(NSSet *)values;

- (void)addTeamSetObject:(PMTeam *)value;
- (void)removeTeamSetObject:(PMTeam *)value;
- (void)addTeamSet:(NSSet *)values;
- (void)removeTeamSet:(NSSet *)values;

- (void)addTournamentSetObject:(PMTournament *)value;
- (void)removeTournamentSetObject:(PMTournament *)value;
- (void)addTournamentSet:(NSSet *)values;
- (void)removeTournamentSet:(NSSet *)values;

@end
