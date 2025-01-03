cmake_minimum_required(VERSION 3.30)

project(wf_engine VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD_REQUIRED 20)
set(CMAKE_CXX_STANDARD 20)

set(REPO_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${REPO_ROOT}/cmake/modules ${REPO_ROOT}/cmake/scripts)

include(target)

# order matters!
set(REQUIRED_MODULES
    engine
    main
)

foreach(module ${REQUIRED_MODULES})
    include(${module})
endforeach()
