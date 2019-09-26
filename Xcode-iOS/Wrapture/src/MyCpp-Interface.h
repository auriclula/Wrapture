//
//  MyCpp-Interface.h
//  Happy-TV
//
//  Created by Administrator on 8/19/19.
//

#ifndef MyCpp_Interface_hpp
#define MyCpp_Interface_hpp

#include <stdio.h>

#ifdef __cplusplus

class boo
{
    private :
        int x = 0;
    
    public:
        int some_method(float);
};  

#else

// C doesn't know about classes, just say it's a struct
typedef struct boo boo;

#endif

// access functions
#ifdef __cplusplus
#define EXPORT_C extern "C"
#else
#define EXPORT_C
#endif

EXPORT_C boo* boo_new(void);
EXPORT_C void boo_delete(boo*);
EXPORT_C int boo_some_method(boo*, float);

#endif /* boo_h */
