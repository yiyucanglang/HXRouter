//
//  HXRegistrationsLoader.h
//  DHXRouter
//
//  Created by James on 2020/4/10.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

///The key represents  appDidFinishLaunching
static char * _Nonnull HXLaunchFinish  = "HXLaunchFinish";

///The key represents  firstscreenDidFinishShow
static char * _Nonnull HXHomeFinish    = "HXHomeFinish";


typedef void (* HXUniformRegisterFunction)(void);

#define HX_DATASECTION "__DATA"
#define HXROUTER_ATTRIBUTE(sectionName) __attribute((used, section(HX_DATASECTION "," #sectionName )))

/*
  code snippet:
     HXExecuteRegistrationAt(<#TimePointKey#>,
     ^{
     <#task#>
     })
  
 */

#define HXExecuteRegistrationAt(TimePointKey, OperationBlcok) \
static void HXRegistrationAt##TimePointKey##AutoExecute(void) {\
   OperationBlcok();\
}\
static HXUniformRegisterFunction registrationat##TimePointKey##function HXROUTER_ATTRIBUTE(TimePointKey) = HXRegistrationAt##TimePointKey##AutoExecute;

@interface HXRegistrationsLoader : NSObject

+ (void)triggerRegistrationsAt:(char *)timePointKey;

@end

NS_ASSUME_NONNULL_END
