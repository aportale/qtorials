# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.
# DEFINES += AVISYNTH26
TEMPLATE = lib
TARGET = ../../screencasts/qtavisynth
SOURCES = qtavisynth.cpp \
    filters.cpp \
    stillimage.cpp \
    tools.cpp \
    subtitle.cpp \
    zoomnpan.cpp \
    svganimation.cpp \
    rgboverlay.cpp \
    title.cpp \
    highlight.cpp
HEADERS = filters.h \
    stillimage.h \
    tools.h \
    subtitle.h \
    zoomnpan.h \
    svganimation.h \
    rgboverlay.h \
    title.h \
    highlight.h \
    paintedrgbclip.h
CONFIG += dll \
    qt
DESTDIR = ./
INCLUDEPATH = .
RESOURCES = qtavisynth.qrc
QT += svg
OTHER_FILES = qtavisynth.avs \
    ../../screencasts/tools.avsi

contains (DEFINES, LINUXIZED_VERSION) {
    HEADERS += /home/niweber/projects/avxsynth/include/avxplugin.h
    INCLUDEPATH += /home/niweber/projects/avxsynth/include/
}
else {
contains (DEFINES, AVISYNTH26) {
    SOURCES += avisynth26\interface.cpp
    HEADERS += avisynth26\avisynth.h
    INCLUDEPATH += avisynth26
}
else {
    HEADERS += avisynth25\avisynth.h
    INCLUDEPATH += avisynth25
}
}
