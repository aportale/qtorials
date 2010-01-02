# DEFINES += AVISYNTH26
TEMPLATE = lib
SOURCES = timelapse.cpp
CONFIG += dll
DESTDIR = ./
QT -= core gui
OTHER_FILES = timelapse.avs
contains (DEFINES, AVISYNTH26) {
    SOURCES += avisynth26\interface.cpp
    HEADERS += avisynth26\avisynth.h
    INCLUDEPATH += avisynth26
}
else {
    HEADERS += avisynth25\avisynth.h
    INCLUDEPATH += avisynth25
}
win32-msvc* {
    QMAKE_CFLAGS_RELEASE -= -MD
    QMAKE_CFLAGS_RELEASE += -MT
    QMAKE_CFLAGS_DEBUG -= -MDd
    QMAKE_CFLAGS_DEBUG += -MTd
    QMAKE_CXXFLAGS_RELEASE -= -MD
    QMAKE_CXXFLAGS_RELEASE += -MT
    QMAKE_CXXFLAGS_DEBUG -= -MDd
    QMAKE_CXXFLAGS_DEBUG += -MTd
}
