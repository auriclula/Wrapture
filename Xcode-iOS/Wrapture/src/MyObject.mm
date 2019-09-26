#import <Foundation/Foundation.h>
#import "MyObject.h"

@implementation MyObject

//MyClassImpl::MyClassImpl( void ) : self ( NULL )
//{
//    self = (__bridge void*)[[MyObject alloc] init];
//}

//MyClassImpl::~MyClassImpl( void )
//{
//    [(__bridge id)self dealloc];
//}

void MyClassImpl::init( void )
{
    self = (__bridge void*)[[MyObject alloc] init];
}

int MyClassImpl::doSomethingWith( void *aParameter )
{
    int * dummy = (int*)aParameter;
    int x = (*dummy);
    return x + 1;
}
/*
- (int) doSomethingWith:(void *) aParameter
{
    return -1;
}
*/

// 'C' access functions
EXPORT_C MyClassImpl* MyClassImpl_init(void)
{
    return new MyClassImpl();
}

EXPORT_C void MyClassImpl_delete(MyClassImpl* thing)
{
    delete thing;
}

EXPORT_C int MyClassImpl_doSomethingWith(MyClassImpl* thing, void * aParameter)
{
    return thing->doSomethingWith(aParameter);
}

@end
