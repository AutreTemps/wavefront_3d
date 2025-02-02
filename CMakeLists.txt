cmake_minimum_required(VERSION 3.30)

project(wf_engine VERSION 0.1 LANGUAGES C CXX)

set(REPO_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${REPO_ROOT}/cmake/modules ${REPO_ROOT}/cmake/scripts)

include(target)

file(GLOB ALL_MODULES "${REPO_ROOT}/cmake/modules/*.cmake")
list(TRANSFORM ALL_MODULES REPLACE "\.cmake$" "")
list(TRANSFORM ALL_MODULES REPLACE "^(.*)\/" "")

# this may be modified in future
set(REQUIRED_MODULES ${ALL_MODULES})

# dependency resolving could be done in plain cmake without python interop,
# but cmake syntax is a pure abomination, so I don't want to
find_package(Python3 REQUIRED COMPONENTS Interpreter)
execute_process(
    COMMAND             ${Python3_EXECUTABLE} ${REPO_ROOT}/cmake/dependency_resolver.py ${REQUIRED_MODULES}
    RESULT_VARIABLE     RESOLVER_STATUS
    OUTPUT_VARIABLE     SORTED_MODULES
    ERROR_VARIABLE      RESOLVER_ERROR_OUT
)

if(${RESOLVER_STATUS} STREQUAL 0)
    foreach(module ${SORTED_MODULES})
        include(${module})
    endforeach()
else()
    message(WARNING "Error from dependency resolver:\n ${RESOLVER_ERROR_OUT}\nTrying to generate with original dependencies list")

    foreach(module ${REQUIRED_MODULES})
        include(${module})
    endforeach()
endif()
