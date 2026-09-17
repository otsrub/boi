#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static UIUserInterfaceIdiom (*original_userInterfaceIdiom)(id, SEL);

static UIUserInterfaceIdiom forcePad_userInterfaceIdiom(id self, SEL _cmd)
{
    return UIUserInterfaceIdiomPad;
}

__attribute__((constructor))
static void ForcePadInit(void)
{
    Class cls = [UIDevice class];
    SEL selector = @selector(userInterfaceIdiom);
    Method method = class_getInstanceMethod(cls, selector);

    if (method) {
        original_userInterfaceIdiom =
            (void *)method_getImplementation(method);

        method_setImplementation(
            method,
            (IMP)forcePad_userInterfaceIdiom
        );
    }
}
