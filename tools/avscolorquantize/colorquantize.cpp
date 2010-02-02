#include "windows.h"
#include "avisynth.h"
#include "FreeImage.h"

class ColorQuantize : public IClip
{
public:
    ColorQuantize(PClip originClip, int paletteSize,
                  bool useGlobalPalette, FREE_IMAGE_QUANTIZE algorithm,
                  IScriptEnvironment* env)
        : m_origin(originClip)
        , m_paletteSize(paletteSize)
        , m_useGlobalPalette(useGlobalPalette)
        , m_algorithm(algorithm)
        , m_targetVideoInfo(originClip->GetVideoInfo())
        , m_globalPalette(0)
    {
        if (!originClip->GetVideoInfo().IsRGB24()) {
            m_originRgb = env->Invoke("ConvertToRgb24", originClip).AsClip();
            m_targetVideoInfo.pixel_type = VideoInfo::CS_BGR24;
        } else {
            m_originRgb = originClip;
        }

        if (m_useGlobalPalette) {
            FIBITMAP *hugeImage =
                    FreeImage_Allocate(m_targetVideoInfo.width,
                                       m_targetVideoInfo.height * m_targetVideoInfo.num_frames,
                                       24);
            for (int frame = 0; frame < m_targetVideoInfo.num_frames; ++frame) {
                PVideoFrame videoFrame = m_originRgb->GetFrame(frame, env);
                const unsigned char* const srcp = videoFrame->GetReadPtr();
                for (int row = 0; row < m_targetVideoInfo.height; ++row) {
                    const int hugeFrameRow = frame * m_targetVideoInfo.height + row;
                    BYTE *dstp = FreeImage_GetScanLine(hugeImage, hugeFrameRow);
                    const unsigned char* const srcrowp = srcp + row * videoFrame->GetPitch();
                    memcpy(dstp, srcrowp, videoFrame->GetRowSize());
                }
            }
            // FreeImage_Save(FIF_PNG, hugeImage, "test.png");
            FreeImage_Unload(hugeImage);
        }
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

        const bool useGlobalPalette = args[2].AsBool(true);

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

        return new ColorQuantize(origin, paletteSize, useGlobalPalette, algorithm, env);
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
    const bool m_useGlobalPalette;
    const FREE_IMAGE_QUANTIZE m_algorithm;
    VideoInfo m_targetVideoInfo;
    RGBQUAD *m_globalPalette;
    PClip m_originRgb;
};

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("ColorQuantize",
                     "[clip]c[palettesize]i[globalpalette]b[algorithm]s",
                     ColorQuantize::CreateColorQuantize, 0);
    return "`ColorQuantize' Reduce colors to a palette";
}
