target_create(
    NAME                   wf3d
    TYPE                   executable
    SOURCE_DIR             main
    CXX_STANDARD           23
    LINK_TARGETS
        engine
        tools
)