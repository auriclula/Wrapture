#ifndef __MYOBJECT_C_INTERFACE_H__
#define __MYOBJECT_C_INTERFACE_H__

#ifdef __cplusplus

class MyClassImpl
{
public:
//    MyClassImpl ( void );
//    ~MyClassImpl( void );
    
    void init( void );
    int doSomethingWith( void * aParameter );
    
private:
    void * self;
};

#else

// C doesn't know about classes, just say it's a struct
typedef struct MyClassImpl MyClassImpl;

#endif

// access functions
#ifdef __cplusplus
#define EXPORT_C extern "C"
#else
#define EXPORT_C
#endif

EXPORT_C MyClassImpl* MyClassImpl_init(void);
EXPORT_C void MyClassImpl_delete(MyClassImpl*);
EXPORT_C int MyClassImpl_doSomethingWith(MyClassImpl* thing, void * aParameter);

#endif
