# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

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
    ../../screencasts/test/* \
    ../../screencasts/tools.avsi

AVISYNTH_FILTERSDK = "C:/Program Files (x86)/AviSynth+/FilterSDK/"
LIBS += $${AVISYNTH_FILTERSDK}/lib/x64/AviSynth.lib
HEADERS += $${AVISYNTH_FILTERSDK}/include/avisynth.h
INCLUDEPATH += $${AVISYNTH_FILTERSDK}/include
