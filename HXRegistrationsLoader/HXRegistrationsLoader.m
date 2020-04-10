//
//  HXStartupLoader.m
//  DHXRouter
//
//  Created by James on 2020/4/10.
//

#import "HXRegistrationsLoader.h"

#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>


static void HXTriggerRegistrationsAt(void *key){
    Dl_info info;
    int ret = dladdr(HXTriggerRegistrationsAt, &info);
    if(ret == 0){
        // fatal error
    }
#ifndef __LP64__
    const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
    unsigned long size = 0;
    uint32_t *memory = (uint32_t*)getsectiondata(mhp, QWLoadableSegmentName, QWLoadableSectionName, & size);
#else /* defined(__LP64__) */
    const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
    unsigned long size = 0;
    uint64_t *memory = (uint64_t*)getsectiondata(mhp, HX_DATASECTION, key, &size);
#endif /* defined(__LP64__) */

    for(int idx = 0; idx < size/sizeof(void*); ++idx){
        HXUniformRegisterFunction func = (HXUniformRegisterFunction)memory[idx];
        func();
    }
}


@implementation HXRegistrationsLoader

+ (void)triggerRegistrationsAt:(char *)timePointKey {
    HXTriggerRegistrationsAt(timePointKey);
}

HXExecuteRegistrationAt(HXLaunchFinish,
^{
   NSLog(@"zzzzzzzzzz");
})

@end
