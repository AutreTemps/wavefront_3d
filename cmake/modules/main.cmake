target_create(
    NAME                   wf_3d
    TYPE                   executable
    SOURCE_DIR             main
    CXX_STANDARD           20
    LINK_TARGETS
        engine
)