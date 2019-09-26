/*
 *  happy.c
 *  written by Holmes Futrell
 *  use however you want
 */

#include "SDL.h"
#include "common.h"
#include <stdbool.h>
#include "ffplay.h"
#include "ffprobe.h"

#include "MyCpp-Interface.h"
#include "MyObjective-C-Interface.h"

static SDL_Window * window;

int
main(int argc, char *argv[])
{
    // include c++ wrapper
    // *** this is not currently used ***
    boo* myInstance = boo_new();
    int x = boo_some_method(myInstance, 12.67);
    x = x + 1;
    boo_delete(myInstance);
    
    // include objective-c wrapper
    // *** this is not currently used ***
    MyClassImpl* myInstance2 = MyClassImpl_init();
    int * y = &x;
    int z = MyClassImpl_doSomethingWith(myInstance2, y);
    z = z + 1;
    MyClassImpl_delete(myInstance2);

    // START of 'C' Code...
    // initialize SDL
    if (SDL_Init(SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) {
        fatalError("Could not initialize SDL");
    }
    
    int index=0, quit=0;
    while(!quit)
    {

    // The specified window size doesn't matter - except for its aspect ratio,
    SDL_Window * window = SDL_CreateWindow2(NULL, 0, 0, 1920, 1080, SDL_WINDOW_FULLSCREEN | SDL_WINDOW_ALLOW_HIGHDPI);

    // main loop
    int done = 0;
    int hack = 0;
    while (!done)
    {
        SDL_Event event;
        
        int j = SDL_GetWindowPlay(window, &hack);
        if(hack==1 && j==0)
            done=2;
        
#if TARGET_OS_TV
        int k = SDL_GetWindowQuit(window, &hack);
        if(hack==1 && k==0)
            { quit=1; done=1; }
#endif
        
        while (SDL_PollEvent(&event))
        {
            Uint32 eventType = event.type;
            if (eventType == SDL_QUIT) {
                done = 1;
            } else if (eventType == SDL_APP_TERMINATING) {
                done = 1;
            }
        }

        SDL_Delay(1);
    }
    
    char buf[1024];
    freopen("/dev/null", "a", stderr);
    setbuf(stderr, buf);
    
    char arg10[] = "ffprobe";
    char * m3u8_url = SDL_GetVideoUrl();
    //  char arg11[] = "https://mediastream.its.txstate.edu/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-_gvpWpGw8k6gjzVyAPtmlQ-TL.mp4/playlist.m3u8";
    char* myargv2[] = { &arg10[0], m3u8_url, NULL };
    int myargc2 = 2;
    
    int index2 = -1;
    if (done == 2 && m3u8_url != NULL) {
        index2 = ffprobe(myargc2, &myargv2[0]);        
        if (index2!=0)
            done = 1;
            //return -1;    //TODO not very elegant
    }
    
    fclose (stderr);
    freopen("/dev/tty", "a", stderr);

    bool is5dot1 = false;
    bool is7dot1 = false;
    char * pc6 = strstr (buf, ", 5.1");
    char * pc8 = strstr (buf, ", 7.1");
    if (pc6!=NULL) is5dot1 = true;
    if (pc8!=NULL) is7dot1 = true;
    
    char arg0[] = "ffplay";
        char arg1[] = "-autoexit";//"-hide_banner";
    char arg2[] = "-af";
    char arg3[] =            "channelmap=0|1:stereo         ";
    if(is5dot1) strcpy(arg3, "channelmap=0|1|3|2|4|5:5.1    ");
    if(is7dot1) strcpy(arg3, "channelmap=0|1|3|2|6|7|4|5:7.1");
     //  char arg4[] = "https://mediastream.its.txstate.edu/streaming/_definst_/mp4:TexasStateUniversity/SRS/MarkErickson-me02/TL-_gvpWpGw8k6gjzVyAPtmlQ-TL.mp4/playlist.m3u8";
    char* myargv[] = { &arg0[0], &arg1[0], &arg2[0], &arg3[0], m3u8_url, NULL };
    int myargc = 5;
    
    index = -1;
    if (done == 2 && m3u8_url != NULL) {
        index = ffplay(myargc, &myargv[0]);
    }
    
//        window->driverData.window.backgroundColor = [UIColor whiteColor];
//    } // while(1)
    
    //  cleanup
    if (window)
        SDL_DestroyWindow(window);
}
    SDL_CloseAudio();
    //uninit_opts();

    // shutdown SDL
    SDL_Quit();
    
    exit(0);
    return index;
}
