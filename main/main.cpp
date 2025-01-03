#include <iostream>

#include <wavefront/point.h>

int main(int argc, char * argv[])
{
    wf::Point p;
    p.x = 2;
    p.y = 24;
    p.z = 31;
    std::cout << p.x * p.y * p.z << std::endl;
    return 0;
}
