#pragma once

#include "windows.h"
#include "avisynth.h"
#include <QImage>

class StillImage : public GenericVideoFilter
{
public:
    StillImage(PClip background, const QImage &image, IScriptEnvironment* env);

    static AVSValue __cdecl CreateElements(AVSValue args, void* user_data,
                                           IScriptEnvironment* env);
    static AVSValue __cdecl CreateSvg(AVSValue args, void* user_data,
                                      IScriptEnvironment* env);
    static AVSValue __cdecl CreateTitle(AVSValue args, void* user_data,
                                        IScriptEnvironment* env);

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;

protected:
    PVideoFrame m_frame;
};
