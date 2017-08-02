
#ifndef GUARD_SIMPLE_H
#define GUARD_SIMPLE_H

#include <thread>

#ifndef HAS_SIMPLE
#error "Not configured"
#endif

inline void simple()
{
    std::thread([]{}).join();
}


#endif
