#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static UIUserInterfaceIdiom forcePad_userInterfaceIdiom(id self, SEL _cmd)
{
    return UIUserInterfaceIdiomPad;
}

static UIWindow *forcePadWindow = nil;

static void ShowForcePadBanner(void)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        forcePadWindow = [[UIWindow alloc] initWithFrame:CGRectMake(20, 70, 220, 45)];
        forcePadWindow.windowLevel = UIWindowLevelAlert + 100;

        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor systemRedColor];

        UILabel *label = [[UILabel alloc] initWithFrame:vc.view.bounds];
        label.text = @"ForcePad LOADED";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        [vc.view addSubview:label];

        forcePadWindow.rootViewController = vc;
        forcePadWindow.hidden = NO;

        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
            dispatch_get_main_queue(),
            ^{
                forcePadWindow.hidden = YES;
                forcePadWindow = nil;
            }
        );
    });
}

__attribute__((constructor))
static void ForcePadInit(void)
{
    Method method = class_getInstanceMethod(
        [UIDevice class],
        @selector(userInterfaceIdiom)
    );

    if (method) {
        method_setImplementation(
            method,
            (IMP)forcePad_userInterfaceIdiom
        );
    }

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
        dispatch_get_main_queue(),
        ^{
            ShowForcePadBanner();
        }
    );
}
