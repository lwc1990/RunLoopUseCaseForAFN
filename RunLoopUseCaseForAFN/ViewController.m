//
//  ViewController.m
//  RunLoopUseCaseForAFN
//
//  Created by syl on 2017/5/5.
//  Copyright © 2017年 personCompany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)runLoopInAFN
{
    /*
     在AFNetworking 2.6.3之前的版本，使用的还是NSURLConnection，可以在AFURLConnectionOperation中找到使用RunLoop的源码：
     + (void)networkRequestThreadEntryPoint:(id)__unused object {
     @autoreleasepool {
     [[NSThread currentThread] setName:@"AFNetworking"];
     
     NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
     [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
     [runLoop run];
     }
     }
     
     + (NSThread *)networkRequestThread {
     static NSThread *_networkRequestThread = nil;
     static dispatch_once_t oncePredicate;
     dispatch_once(&oncePredicate, ^{
     _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
     [_networkRequestThread start];
     });
     
     return _networkRequestThread;
     }
     AFNetworking都是通过调用 [NSObject performSelector:onThread:..] 将这个任务扔到了后台线程的 RunLoop 中。
     - (void)start {
     [self.lock lock];
     if ([self isCancelled]) {
     [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
     } else if ([self isReady]) {
     self.state = AFOperationExecutingState;
     
     [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
     }
     [self.lock unlock];
     }
     我们在使用NSURLConnection 或者NSStream时，也需要考虑到RunLoop问题，因为默认情况下这两个类的对象生成后，都是在当前线程的NSDefaultRunLoopMode模式下执行任务。如果是在主线程，那么就会出现滚动ScrollView以及其子视图时，主线程的RunLoop切换到UITrackingRunLoopMode模式，那么NSURLConnection或者NSStream的回调就无法执行了。
     
     要解决这个问题，有两种方式：
     第一种方式是创建出NSURLConnection对象或者NSStream对象后，再调用 - (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSRunLoopMode)mode,设置RunLoopMode即可。需要注意的是NSURLConnection必须使用其初始化构造方法- (nullable instancetype)initWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate startImmediately:(BOOL)startImmediately来创建对象，设置Mode才会起作用。
     
     第二种方式，就是所有的任务都在子线程中执行，并保证子线程的RunLoop正常运行即可（即上面AFNetworking的做法，因为主线程的RunLoop切换到UITrackingRunLoopMode，并不影响其他线程执行哪个mode中的任务，计算机CPU是在每一个时间片切换到不同的线程去跑一会，呈现出的多线程效果）。
     

     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
