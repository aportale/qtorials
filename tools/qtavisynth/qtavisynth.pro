# This work is licensed under the Creative Commons
# Attribution-Noncommercial-Share Alike 3.0 Unported
# License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-sa/3.0/
# or send a letter to Creative Commons,
# 171 Second Street, Suite 300, San Francisco,
# California, 94105, USA.

#DEFINES += AVISYNTH26

TEMPLATE = lib

SOURCES = \
    qtavisynth.cpp \
    filters.cpp

HEADERS = filters.h

CONFIG += \
    dll \
    qt

DESTDIR = ./

INCLUDEPATH = .

RESOURCES = qtavisynth.qrc

QT += svg

OTHER_FILES = qtavisynth.avs

contains (DEFINES, AVISYNTH26) {
    SOURCES += avisynth26\interface.cpp
    HEADERS += avisynth26\avisynth.h
    INCLUDEPATH += avisynth26
} else {
    HEADERS += avisynth25\avisynth.h
    INCLUDEPATH += avisynth25
}
