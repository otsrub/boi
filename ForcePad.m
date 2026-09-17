#include <unistd.h>

__attribute__((constructor))
static void ForcePadTest(void)
{
    _exit(173);
}
