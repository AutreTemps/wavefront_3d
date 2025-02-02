include_guard(GLOBAL)

include(utils)

function(target_create)
    set(__options
        EXPORT_INCLUDES
    )

    set(__single_required
        NAME
        TYPE
        SOURCE_DIR
    )

    set(__single_optional
        CXX_STANDARD
    )

    set(__multi
        INCLUDE_DIRS
        LINK_TARGETS
        LINK_LIBRARIES
    )

    utils_parse_arguments(ARG "${__options}" "${__single_required}" "${__single_optional}" "${__multi}" ${ARGN})

    set(__type_enum
        static_lib
        shared_lib
        header_only
        executable
    )
    utils_check_enum_entry("${ARG_TYPE}" "${__type_enum}")

    cmake_language(CALL "create_${ARG_TYPE}" ${ARG_NAME})

    target_init_props()

    target_setup_deps()
    target_setup_includes()
    target_setup_sources()

    set_target_properties(${ARG_NAME} PROPERTIES
        PROP_LINK_TARGETS "${PROP_LINK_TARGETS}"
        PROP_INCLUDE_DIRS "${PROP_INCLUDE_DIRS}"
    )
    if(ARG_CXX_STANDARD)
        set_target_properties(${ARG_NAME} PROPERTIES
            CXX_STANDARD "${ARG_CXX_STANDARD}"
        )
    endif()
endfunction()

macro(target_init_props)
    set(PROP_LINK_TARGETS)
    set(PROP_INCLUDE_DIRS)
endmacro()

macro(target_setup_deps)
    list(APPEND PROP_LINK_TARGETS ${ARG_LINK_TARGETS})
    list(APPEND PROP_LINK_TARGETS ${ARG_LINK_LIBRARIES})

    target_link_libraries(${ARG_NAME} ${PROP_LINK_TARGETS})
endmacro()

macro(target_setup_includes)
    if(ARG_EXPORT_INCLUDES)
        set(PROP_INCLUDE_DIRS ${ARG_SOURCE_DIR} ${ARG_INCLUDE_DIRS})
    endif()

    list(APPEND ARG_INCLUDE_DIRS
        ${ARG_SOURCE_DIR}
        ${CMAKE_SOURCE_DIR}
        ${CMAKE_CURRENT_BINARY_DIR}
    )

    if(PROP_LINK_TARGETS)
        foreach(target ${PROP_LINK_TARGETS})
            get_target_property(includeDir ${target} PROP_INCLUDE_DIRS)
            list(APPEND ARG_INCLUDE_DIRS ${includeDir})
        endforeach()
    endif()

    list(REMOVE_DUPLICATES ARG_INCLUDE_DIRS)
    if(NOT ${ARG_TYPE} STREQUAL header_only)
        target_include_directories(${ARG_NAME} PRIVATE ${ARG_INCLUDE_DIRS})
    else()
        target_include_directories(${ARG_NAME} INTERFACE ${ARG_INCLUDE_DIRS})
    endif()
endmacro()

function(target_setup_sources)
    file(GLOB_RECURSE ALL_FILES "${ARG_SOURCE_DIR}/[^.]*")

    set(HEADERS ${ALL_FILES})
    list(FILTER HEADERS INCLUDE REGEX "[.](h|hpp)$")
    set(SOURCES ${ALL_FILES})
    list(FILTER SOURCES INCLUDE REGEX "[.](c|cpp)$")

    set(ALL_SOURCES ${HEADERS} ${SOURCES})
    target_sources(${ARG_NAME} PRIVATE ${ALL_SOURCES})
endfunction()

macro(create_static_lib NAME)
    add_library(${NAME} STATIC)
endmacro()

macro(create_shared_lib NAME)
    add_library(${NAME} SHARED)
endmacro()

macro(create_header_only NAME)
    add_library(${NAME} INTERFACE)
endmacro()

macro(create_executable NAME)
    add_executable(${NAME})
endmacro()
