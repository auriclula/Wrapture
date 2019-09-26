//
//  MyCpp-Interface.cpp
//  Happy-TV
//
//  Created by Administrator on 8/19/19.
//

#include "MyCpp-Interface.h"

// C++ access functions
int boo::some_method(float f)
{
    return static_cast<int>(f);
}



// 'C' access functions
EXPORT_C boo* boo_new(void)
{
    return new boo();
}

EXPORT_C void boo_delete(boo* thing)
{
    delete thing;
}

EXPORT_C int boo_some_method(boo* thing, float f)
{
    return thing->some_method(f);
}
