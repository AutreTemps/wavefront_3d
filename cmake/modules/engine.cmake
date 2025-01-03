target_create(
    NAME                   engine
    TYPE                   static_lib
    SOURCE_DIR             engine
    EXPORT_INCLUDES
    CXX_STANDARD           20
    INCLUDE_DIRS
        engine/domain
        emgine/wavefront
)
