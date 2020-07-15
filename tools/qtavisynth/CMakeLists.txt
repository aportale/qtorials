cmake_minimum_required (VERSION 3.14)

project(QtAviSynth VERSION "0.9" LANGUAGES C CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Gui Svg REQUIRED)

file(TO_CMAKE_PATH "$ENV{ProgramFiles\(x86\)}" program_files_x86)
set(avisynth_filtersdk "${program_files_x86}/AviSynth+/FilterSDK")

add_library(
    qtavisynth SHARED
    qtavisynth.cpp
    qtavisynth.qrc
    filters.h filters.cpp
    highlight.h highlight.cpp
    rgboverlay.h rgboverlay.cpp
    stillimage.h stillimage.cpp
    subtitle.h subtitle.cpp
    svganimation.h svganimation.cpp
    title.h title.cpp
    tools.h tools.cpp
    zoomnpan.h zoomnpan.cpp
)

target_include_directories(
    qtavisynth PRIVATE
    "${avisynth_filtersdk}/include"
)

target_link_libraries(
    qtavisynth PRIVATE
    "${avisynth_filtersdk}/lib/x64/AviSynth.lib"
)

target_link_libraries(
    qtavisynth PRIVATE
    Qt5::Gui
    Qt5::Svg
)

set(LIBRARY_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../screencasts/")

# Testing:
#    choco install virtualdub2 -a
# Qt Creator run configuration executable:
#    %{Env:ProgramData}\chocolatey\lib\virtualdub2\tools\VirtualDub64.exe
# Qt Creator run configuration command line argument:
#    %{sourceDir}\..\..\screencasts\test\qtavisynth_rgbpattern.avs
# Qt Creator run configuration environment, prepend to "Path"
#    ${QTDIR}\bin;
