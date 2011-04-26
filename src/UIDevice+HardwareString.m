//
//  UIDevice+PlatformString.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/20/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "UIDevice+HardwareString.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice(HardwareString)
-(NSString *)hardware{
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *hardware = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
  free(machine);
  return hardware;
}
@end
