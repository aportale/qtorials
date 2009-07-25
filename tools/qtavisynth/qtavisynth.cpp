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
#include <QtGui>

class QtAviSynth : public GenericVideoFilter
{
public:
    QtAviSynth(PClip _child, IScriptEnvironment* env);
    ~QtAviSynth();
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env);

private:
    static int argc;
    static char *args[];
    QApplication *app;
};

int QtAviSynth::argc = 1;
char *QtAviSynth::args[] = {"."};

QtAviSynth::QtAviSynth(PClip _child, IScriptEnvironment* env)
    : GenericVideoFilter(_child)
    , app(0)
{
    if (!vi.IsRGB32())
        env->ThrowError("QtAviSynth: input to filter must be in RGB32");
    app = new QApplication(argc, args); // Is that too silly?
}

QtAviSynth::~QtAviSynth()
{
    if (app)
        delete app;
}

PVideoFrame __stdcall QtAviSynth::GetFrame(int n, IScriptEnvironment* env)
{
    PVideoFrame src = child->GetFrame(n, env);
    PVideoFrame dst = env->NewVideoFrame(vi);
    const unsigned char* srcp = src->GetReadPtr();
    unsigned char* dstp = dst->GetWritePtr();
    const int dst_pitch = dst->GetPitch();
    const int dst_width = dst->GetRowSize();
    const int dst_height = dst->GetHeight();
    const int src_pitch = src->GetPitch();
    const int src_width = src->GetRowSize();
    const int src_height = src->GetHeight();
    int w, h;

    QImage i(dst_width / 4, dst_height, QImage::Format_ARGB32_Premultiplied);

    i.fill(Qt::white);
    QPainter p(&i);
    p.setRenderHint(QPainter::Antialiasing);
    p.setPen(Qt::red);
    p.setBrush(Qt::yellow);
    p.drawEllipse(10.5, 10.5, 50.5 + n, 50.5 + n);
    p.setPen(Qt::blue);
    p.drawText(20, 20, "Hello AviSynth");
    p.setPen(Qt::green);
    p.drawText(50, 50, QString::number(n));
    p.end();

    for (int row = 0; row < dst_height; ++row) {
        memcpy(dstp, i.scanLine(dst_height - row - 1), dst_width);
        dstp += dst_pitch;
    }

    return dst;
}

AVSValue __cdecl Create_QtAviSynth(AVSValue args, void* user_data, IScriptEnvironment* env)
{
    return new QtAviSynth(args[0].AsClip(), env);
}

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("QtAviSynth", "c", Create_QtAviSynth, 0);
    return "`QtAviSynth' QtAviSynth plugin";
}
