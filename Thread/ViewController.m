//
//  ViewController.m
//  Thread
//
//  Created by wanghuiyong on 28/12/2016.
//  Copyright © 2016 wanghuiyong. All rights reserved.
//

#import "ViewController.h"
#import "pthread.h"
#import "TicketManger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#if false
    TicketManger *manger = [[TicketManger alloc] init];
    [manger startToSell];
#endif
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"pThread" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickpThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 30);
    [btn setTitle:@"NSThread" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickNSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 300, 100, 30);
    [btn setTitle:@"GCD" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickGCD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pThread

- (void)clickpThread {
    pthread_t pThread;
    pthread_create(&pThread, NULL, runpThread, NULL);
    NSLog(@"main pThread");
    for (char i = 'a'; i < 'a' + 10; i++)
    {
        NSLog(@"%c", i);
        sleep(1);
    }
}

void *runpThread(void *data) {
	NSLog(@"child pThread");
    for (int i = 0; i < 10; i++)
    {
        NSLog(@"%d", i);
        sleep(1);
    }
    return NULL;
}

#pragma mark - NSThread

- (void)clickNSThread {
//    方式1(需要线程对象)
    NSThread *thread1  = [[NSThread alloc] initWithTarget:self selector:@selector(runNSThread) object:nil];
    [thread1 setName:@"t1"];
    [thread1 setThreadPriority:0.2];
    [thread1 start];
    
    NSThread *thread2  = [[NSThread alloc] initWithTarget:self selector:@selector(runNSThread) object:nil];
    [thread2 setName:@"t2"];
    [thread2 setThreadPriority:0.8];
    [thread2 start];
    
//    方式2
//    [NSThread detachNewThreadSelector:@selector(runNSThread) toTarget:self withObject:nil];
//    方式3
//    [self performSelectorInBackground:@selector(runNSThread) withObject:nil];

    for (char i = 'a'; i < 'a' + 3; i++)
    {
        NSLog(@"main NSThread i = %c", i);
        sleep(1);
    }
}

- (void)runNSThread {
    NSString *name = [NSThread currentThread].name;
    for (int i = 0; i < 3; i++)
    {
        NSLog(@"child NSThread %@ i = %d", name, i);
        sleep(1);
    }
    [self performSelectorOnMainThread:@selector(runMainNSThread) withObject:nil waitUntilDone:YES];
}

- (void)runMainNSThread {
    NSLog(@"return main NSThread");
}

#pragma mark - GCD

- (void)clickGCD {
    NSLog(@"mian thread");
#if false
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"child thread");
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"refresh UI");
        });
    });
#endif
    
#if false
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"task 1 start");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"task 1 end");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"task 2 start");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"task 2 end");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"task 3 start");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"task 3 end");
    });
#endif
    
#if false
    dispatch_queue_t queue = dispatch_queue_create("GCD queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"task 1 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 1 end");
        [NSThread sleepForTimeInterval:1];
    });
    dispatch_async(queue, ^{
        NSLog(@"task 2 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 2 end");
        [NSThread sleepForTimeInterval:1];
    });
    dispatch_async(queue, ^{
        NSLog(@"task 3 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 3 end");
        [NSThread sleepForTimeInterval:1];
    });
#endif
    
    dispatch_queue_t queue = dispatch_queue_create("GCD queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"task 1 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 1 end");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"task 2 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 2 end");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"task 3 start"); 
        [NSThread sleepForTimeInterval:1];
        NSLog(@"task 3 end");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"all tasks return notify"); 
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"return main thread refresh UI");
        });
    });
}

@end
