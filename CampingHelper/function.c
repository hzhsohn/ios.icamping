//
//  function.c
//  CampingHelper
//
//  Created by Han Sohn on 12-3-6.
//  Copyright (c) 2012年 Han.zh. All rights reserved.
//

#include <stdio.h>
#include "function.h"
#include <sys/time.h>

unsigned long Sys_GetTime()
{
	/* linux */
	struct timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec*1000+tv.tv_usec/1000);

}
