# Visual test for the Painting functions

find_package(Qt6 REQUIRED COMPONENTS Widgets)

add_executable(
    qtavisynth_filtertest WIN32
    test.cpp
    ../qtavisynth.qrc
    ../painting.h ../painting.cpp
    ../tools.h ../tools.cpp
)

target_include_directories(
    qtavisynth_filtertest PRIVATE
    ..
    "${avisynth_include_dir}"
)

target_compile_definitions(
    qtavisynth_filtertest PRIVATE
    SCREENCASTS_DIR="${CMAKE_CURRENT_SOURCE_DIR}/../../../screencasts"
)

target_link_libraries(
    qtavisynth_filtertest PRIVATE
    ${avisynth_library}
    Qt6::Gui
    Qt6::Svg
    Qt6::Widgets
)

# Smoke test and the AviSynth scripts it is run on. Not built, only listed to show them in
# the IDE's project tree
file(GLOB test_scripts CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../screencasts/test/*.avs"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../screencasts/test/*.avsi"
)
add_custom_target(
    qtavisynth_testscripts
    SOURCES
    check_avs.py
    ${test_scripts}
)
