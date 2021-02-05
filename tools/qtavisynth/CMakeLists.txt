cmake_minimum_required (VERSION 3.14)

project(QtAviSynth VERSION "0.9" LANGUAGES C CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Gui Svg Quick REQUIRED)

file(TO_CMAKE_PATH "$ENV{ProgramFiles\(x86\)}" program_files_x86)
set(avisynth_filtersdk "${program_files_x86}/AviSynth+/FilterSDK")

set(intropainter_dir "../../../stuff/qtavisynthqml/intro2")

add_library(
    qtavisynth SHARED
    qtavisynth.cpp
    qtavisynth.qrc
    filters.h filters.cpp
    highlight.h highlight.cpp
    qmlanimation.h qmlanimation.cpp
    stillimage.h stillimage.cpp
    subtitle.h subtitle.cpp
    svganimation.h svganimation.cpp
    tools.h tools.cpp
    zoomnpan.h zoomnpan.cpp

    qtintro.h qtintro.cpp
    ${intropainter_dir}/animationpainter.h ${intropainter_dir}/animationpainter.cpp
    ${intropainter_dir}/intropainter.h ${intropainter_dir}/intropainter.cpp ${intropainter_dir}/intropainter.qrc
    ${intropainter_dir}/lowerthirdpainter.h ${intropainter_dir}/lowerthirdpainter.cpp
    ${intropainter_dir}/qttitleanimationpainter.h ${intropainter_dir}/qttitleanimationpainter.cpp
)

target_include_directories(
    qtavisynth PRIVATE
    "${avisynth_filtersdk}/include"
    ${intropainter_dir}
)

target_link_libraries(
    qtavisynth PRIVATE
    "${avisynth_filtersdk}/lib/x64/AviSynth.lib"
)

target_link_libraries(
    qtavisynth PRIVATE
    Qt5::Gui
    Qt5::Svg
    Qt5::Quick
    Qt5::WidgetsPrivate
)

set(LIBRARY_OUTPUT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../screencasts/")

# Testing:
#    choco install virtualdub2 -a
# Qt Creator run configuration executable:
#    %{Env:ProgramData}\chocolatey\lib\virtualdub2\tools\VirtualDub64.exe
#    %{Env:ProgramData}\chocolatey\lib\mpv.install\tools\mpv.exe
# Qt Creator run configuration command line argument:
#    %{sourceDir}\..\..\screencasts\test\qtavisynth_all.avs
# Qt Creator run configuration environment, prepend to "Path"
#    ${QTDIR}\bin;
