/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include "windows.h"
#include "avisynth.h"
#include "filters.h"
#include <QtGui>

class QtorialsOldstyle : public GenericVideoFilter
{
public:
    QtorialsOldstyle(PClip _child, IScriptEnvironment* env)
        : GenericVideoFilter(_child)
    {
        if (!vi.IsRGB32())
            env->ThrowError("QtorialsOldstyle: input to filter must be in RGB32");
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame src = child->GetFrame(n, env);

        unsigned char* srcp = src->GetWritePtr();
        const int src_width = src->GetRowSize();
        const int src_height = src->GetHeight();
        const int src_pitch = src->GetPitch();

        QImage i(srcp, src_width / 4, src_height, src_pitch, QImage::Format_ARGB32_Premultiplied);

        QPainter p(&i);
        paintOldStyle(&p, QRect(0, 0, src_width / 4, src_height));

        return src;
    }

    static AVSValue __cdecl Create(AVSValue args, void* user_data, IScriptEnvironment* env)
    {
        return new QtorialsOldstyle(args[0].AsClip(), env);
    }
};

class QtorialsRgbPatterns : public GenericVideoFilter
{
public:
    QtorialsRgbPatterns(PClip _child, IScriptEnvironment* env)
        : GenericVideoFilter(_child)
    {
        if (!vi.IsRGB32())
            env->ThrowError("QtorialsRgbPatterns: input to filter must be in RGB32");
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame src = env->NewVideoFrame(vi);
        unsigned char* srcp = src->GetWritePtr();
        const int src_width = src->GetRowSize();
        const int src_height = src->GetHeight();
        const int src_pitch = src->GetPitch();

        QImage i(srcp, src_width / 4, src_height, src_pitch, QImage::Format_ARGB32_Premultiplied);

        QPainter p(&i);
        paintRgbPatterns(&p, QRect(0, 0, src_width / 4, src_height));

        return src;
    }

    static AVSValue __cdecl Create(AVSValue args, void* user_data, IScriptEnvironment* env)
    {
        return new QtorialsRgbPatterns(args[0].AsClip(), env);
    }
};

class QtorialsTitle : public GenericVideoFilter
{
public:
    QtorialsTitle(PClip _child, IScriptEnvironment* env, const char* title)
        : GenericVideoFilter(_child)
    {
        m_title = QString::fromLatin1(title).replace(QLatin1String("\\n"), QLatin1String("\n"));
        if (!vi.IsRGB32())
            env->ThrowError("QtorialsTitle: input to filter must be in RGB32");
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame src = env->NewVideoFrame(vi);
        unsigned char* srcp = src->GetWritePtr();
        const int src_width = src->GetRowSize();
        const int src_height = src->GetHeight();
        const int src_pitch = src->GetPitch();

        QImage i(srcp, src_width / 4, src_height, src_pitch, QImage::Format_RGB32);

        QPainter p(&i);
        paintTitle(&p, QRect(0, 0, src_width / 4, src_height), m_title);

        return src;
    }

    static AVSValue __cdecl Create(AVSValue args, void* user_data, IScriptEnvironment* env)
    {
        return new QtorialsTitle(args[0].AsClip(), env, args[1].AsString());
    }

private:
    QString m_title;
};

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtorialsOldstyle", "c", QtorialsOldstyle::Create, 0);
    env->AddFunction("QtorialsRgbPatterns", "c", QtorialsRgbPatterns::Create, 0);
    env->AddFunction("QtorialsTitle", "cs", QtorialsTitle::Create, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
