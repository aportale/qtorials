#pragma once

#include <windows.h>
#include "avisynth.h"
#include <lowerthirdpainter.h>
#include <intropainter.h>

class QtIntro : public GenericVideoFilter
{
public:
    QtIntro(PClip background, const QString &title, const QString &subtitle);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQtIntro(AVSValue args, void* user_data,
                                          IScriptEnvironment* env);

protected:
    IntroPainter m_introPainter;
};

class QtLowerThird : public GenericVideoFilter
{
public:
    QtLowerThird(PClip background, const QString &title);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQtLowerThird(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

protected:
    LowerThirdPainter m_lowerThirdPainter;
};
