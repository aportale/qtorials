#pragma once

#include <windows.h>
#include "avisynth.h"
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
