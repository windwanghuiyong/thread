//
//  TicketManger.m
//  Thread
//
//  Created by wanghuiyong on 01/01/2017.
//  Copyright © 2017 wanghuiyong. All rights reserved.
//

#import "TicketManger.h"

#define _TOTAL 30

@interface TicketManger ()

@property int leftCount;
@property int soldCount;

@property (nonatomic, strong) NSThread *threadBeiJing;
@property (nonatomic, strong) NSThread *threadShangHai;
@property (nonatomic, strong) NSCondition *ticketCondition;

@end

@implementation TicketManger

- (instancetype) init {
    if (self = [super init]) {
        self.leftCount = _TOTAL;
        self.ticketCondition = [[NSCondition alloc] init];
        self.threadBeiJing = [[NSThread alloc] initWithTarget:self selector:@selector(sell) object:nil];
        self.threadShangHai = [[NSThread alloc] initWithTarget:self selector:@selector(sell) object:nil];
        [self.threadBeiJing setName:@"BeiJing"];
        [self.threadShangHai setName:@"ShangHai"];
    }
    return self;
}

- (void)sell {
    while (true) {
//        @synchronized (self) {
            [self.ticketCondition lock];
            if (self.leftCount > 0) {
                [NSThread sleepForTimeInterval:0.2];
                self.leftCount--;
                self.soldCount = _TOTAL - self.leftCount;
                NSLog(@"%@: sold %d, left %d", [NSThread currentThread].name, self.soldCount, self.leftCount);
            }
            [self.ticketCondition unlock];
//        }
    }
}

- (void)startToSell {
    [self.threadBeiJing start];
    [self.threadShangHai start];
}

@end
