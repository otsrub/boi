__attribute__((used))
static const char marker[] = "LOGIC_CRASH_TEST_20260917";

__attribute__((constructor))
static void LogicCrashTest(void)
{
    __builtin_trap();
}
