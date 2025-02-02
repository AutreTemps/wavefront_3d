target_create(
    NAME                   engine
    TYPE                   static_lib
    SOURCE_DIR             engine
    EXPORT_INCLUDES
    CXX_STANDARD           23
    INCLUDE_DIRS
        engine/domain
        engine/wavefront
    LINK_TARGETS
        tools
)
