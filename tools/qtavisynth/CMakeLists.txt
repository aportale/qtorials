cmake_minimum_required (VERSION 3.20)

project(QtAviSynth VERSION "0.9" LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Gui GuiPrivate Svg Quick)

if(WIN32)
    file(TO_CMAKE_PATH "$ENV{ProgramFiles\(x86\)}" program_files_x86)
    set(avisynth_filtersdk "${program_files_x86}/AviSynth+/FilterSDK")
    set(avisynth_include_dir "${avisynth_filtersdk}/include/x64")
    set(avisynth_library "${avisynth_filtersdk}/lib/x64/AviSynth.lib")
else()
    # The plugin only needs the headers: AviSynth+ passes the function table in when it loads
    # the plugin, so nothing is linked. Expects the AviSynthPlus checkout next to this
    # repository, override with -DAVISYNTH_SOURCE_DIR=<path>.
    cmake_path(APPEND CMAKE_CURRENT_SOURCE_DIR "../../../AviSynthPlus"
               OUTPUT_VARIABLE default_avisynth_source_dir)
    cmake_path(NORMAL_PATH default_avisynth_source_dir)
    set(AVISYNTH_SOURCE_DIR "${default_avisynth_source_dir}"
        CACHE PATH "AviSynthPlus source directory")
    set(avisynth_include_dir "${AVISYNTH_SOURCE_DIR}/avs_core/include")
    set(avisynth_library "")
    if(NOT EXISTS "${avisynth_include_dir}/avisynth.h")
        message(FATAL_ERROR "avisynth.h not found in ${avisynth_include_dir}. "
                            "Set AVISYNTH_SOURCE_DIR to an AviSynthPlus checkout.")
    endif()
endif()

add_library(
    qtavisynth SHARED
    qtavisynth.cpp
    qtavisynth.qrc
    painting.h painting.cpp
    highlight.h highlight.cpp
    qmlanimation.h qmlanimation.cpp
    sourcefilter.h sourcefilter.cpp
    stillimage.h stillimage.cpp
    subtitle.h subtitle.cpp
    svganimation.h svganimation.cpp
    tools.h tools.cpp
    zoomnpan.h zoomnpan.cpp
)

target_include_directories(
    qtavisynth PRIVATE
    "${avisynth_include_dir}"
)

target_link_libraries(
    qtavisynth PRIVATE
    ${avisynth_library}
)

target_link_libraries(
    qtavisynth PRIVATE
    Qt6::Gui
    Qt6::GuiPrivate # QRhi
    Qt6::Svg
    Qt6::Quick
)

set(LIBRARY_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../screencasts/")

add_subdirectory(test)

# Not built, only listed to show the files in the IDE's project tree
add_custom_target(
    qtavisynth_otherfiles
    SOURCES
    README.md
    qtavisynth.avs
)

# See README.md for requirements, building and testing
