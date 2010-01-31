#include "windows.h"
#include "avisynth.h"
#include "FreeImage.h"

class ColorQuantize : public IClip
{
public:
    ColorQuantize(PClip originClip, int paletteSize, bool globalPalette,
                  FREE_IMAGE_QUANTIZE algorithm)
        : m_origin(originClip)
        , m_paletteSize(paletteSize)
        , m_globalPalette(globalPalette)
        , m_algorithm(algorithm)
        , m_targetVideoInfo(originClip->GetVideoInfo())
    {
        m_targetVideoInfo.pixel_type = VideoInfo::CS_BGR32;
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame dst = env->NewVideoFrame(m_targetVideoInfo);
        unsigned char* const dstp = dst->GetWritePtr();
        return dst;
    }

    static AVSValue __cdecl CreateColorQuantize(AVSValue args, void* /* user_data */,
                                           IScriptEnvironment* env)
    {
        PClip origin = args[0].AsClip();

        const int mimumPaletteSize = 2;
        const int maxiumPaletteSize = 256;
        const int paletteSize = args[1].AsInt(maxiumPaletteSize);
        if (paletteSize < mimumPaletteSize || paletteSize > maxiumPaletteSize)
            env->ThrowError("ColorQuantize: Invalid palette size %d.\n"
                            "Supported range is between '%d' and '%d'."
                            ,paletteSize, mimumPaletteSize, maxiumPaletteSize);

        const bool globalPalette = args[2].AsBool(true);

        static const char* const algorithms[] = {
            "Xiaolin Wu",
            "NeoQuant"
        };
        const char* const algorithmString = args[3].AsString(algorithms[0]);
        FREE_IMAGE_QUANTIZE algorithm = FIQ_WUQUANT;
        if (strcmp(algorithmString, algorithms[0]) == 0)
            algorithm = FIQ_WUQUANT;
        else if (strcmp(algorithmString, algorithms[1]) == 0)
            algorithm = FIQ_NNQUANT;
        else
            env->ThrowError("ColorQuantize: Invalid algorithm %s.\n"
                            "Supported are '%s' and '%s'."
                            ,algorithmString, algorithms[0], algorithms[1]);

        return new ColorQuantize(origin, paletteSize, globalPalette, algorithm);
    }

    bool __stdcall GetParity(int /* n */)
    {
        return false;
    }

    const VideoInfo& __stdcall GetVideoInfo()
    {
        return m_targetVideoInfo;
    }

    void __stdcall SetCacheHints(int /* cachehints */, int /* frame_range*/)
    {
    }

    void __stdcall GetAudio(void* buf, __int64 start, __int64 count,
                            IScriptEnvironment* env)
    {
        m_origin->GetAudio(buf, start, count, env);
    }

protected:
    PClip m_origin;
    const int m_paletteSize;
    const bool m_globalPalette;
    const FREE_IMAGE_QUANTIZE m_algorithm;
    VideoInfo m_targetVideoInfo;
};

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("ColorQuantize",
                     "[clip]c[palettesize]i[globalpalette]b[algorithm]s",
                     ColorQuantize::CreateColorQuantize, 0);
    return "`ColorQuantize' Reduce colors to a palette";
}
