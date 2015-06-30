#include "windows.h"
#include "avisynth.h"
#include "FreeImage.h"

class ColorQuantize : public IClip
{
public:
    ColorQuantize(PClip originClip, int paletteSize,
                  bool useGlobalPalette, FREE_IMAGE_QUANTIZE algorithm,
                  const char *globalPaletteOutputFile, IScriptEnvironment* env)
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
                const PVideoFrame videoFrame = m_originRgb->GetFrame(frame, env);
                copyVideoFrameToImage(m_originRgb->GetFrame(frame, env),hugeImage, frame * m_targetVideoInfo.height);
            }
            FIBITMAP *quantizedImage =
                    FreeImage_ColorQuantizeEx(hugeImage, algorithm, m_paletteSize);
            FreeImage_Unload(hugeImage);
            m_globalPalette = new RGBQUAD[m_paletteSize];
            memcpy(m_globalPalette, FreeImage_GetPalette(quantizedImage), m_paletteSize * sizeof(RGBQUAD));
            FreeImage_Unload(quantizedImage);
            if (globalPaletteOutputFile)
                savePaletteImage(globalPaletteOutputFile, m_globalPalette, m_paletteSize);
        }
    }

    ~ColorQuantize()
    {
        if (m_globalPalette)
            delete[] m_globalPalette;
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame dst = env->NewVideoFrame(m_targetVideoInfo);
        unsigned char* const dstp = dst->GetWritePtr();

        FIBITMAP *frameImage =
                FreeImage_Allocate(m_targetVideoInfo.width, m_targetVideoInfo.height, 24);
        copyVideoFrameToImage(m_originRgb->GetFrame(n, env), frameImage);

        const int reservedPaletteSize = m_useGlobalPalette ? m_paletteSize : 0;
        FIBITMAP *quantizedFrameImage =
                FreeImage_ColorQuantizeEx(frameImage, FIQ_NNQUANT, m_paletteSize, reservedPaletteSize, m_globalPalette);
        FreeImage_Unload(frameImage);
        FIBITMAP *quantizedFrameImageRgb24 =
                FreeImage_ConvertTo24Bits(quantizedFrameImage);
        FreeImage_Unload(quantizedFrameImage);
        for (int row = 0; row < m_targetVideoInfo.height; ++row) {
            unsigned char* dstrowp = dstp + row * dst->GetPitch();
            const BYTE* const srcp = FreeImage_GetScanLine(quantizedFrameImageRgb24, row);
            memcpy(dstrowp, srcp, dst->GetRowSize());
        }
        FreeImage_Unload(quantizedFrameImageRgb24);
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
        FREE_IMAGE_QUANTIZE algorithm = FIQ_NNQUANT;
        if (strcmp(algorithmString, algorithms[0]) == 0)
            algorithm = FIQ_WUQUANT;
        else if (strcmp(algorithmString, algorithms[1]) == 0)
            algorithm = FIQ_NNQUANT;
        else
            env->ThrowError("ColorQuantize: Invalid algorithm %s.\n"
                            "Supported are '%s' and '%s'."
                            ,algorithmString, algorithms[0], algorithms[1]);

        const char* const globalpaletteoutputfile = args[4].AsString(NULL);
        if (globalpaletteoutputfile && !useGlobalPalette)
            env->ThrowError("ColorQuantize: globalpaletteoutputfile can\n"
                            "only be chosen if a global palette is used."
                            ,paletteSize, mimumPaletteSize, maxiumPaletteSize);

        return new ColorQuantize(origin, paletteSize, useGlobalPalette,
                                 algorithm, globalpaletteoutputfile, env);
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
    static void copyVideoFrameToImage(const PVideoFrame &videoFrame,
                                      FIBITMAP *image, int rowOffset = 0)
    {
        const unsigned char* const srcp = videoFrame->GetReadPtr();
        for (int row = 0; row < videoFrame->GetHeight(); ++row) {
            BYTE *dstp = FreeImage_GetScanLine(image, rowOffset + row);
            const unsigned char* const srcrowp = srcp + row * videoFrame->GetPitch();
            memcpy(dstp, srcrowp, videoFrame->GetRowSize());
        }
    }

    void savePaletteImage(const char *fileName, RGBQUAD *palette, int entries)
    {
        FIBITMAP *image = FreeImage_Allocate(entries, 1, 8);
        memcpy(FreeImage_GetPalette(image), palette, entries * sizeof(RGBQUAD));
        BYTE *dstp = FreeImage_GetScanLine(image, 0);
        for (int i = 0; i < entries; ++i)
            dstp[i] = BYTE(i);
        FreeImage_Save(FIF_PNG, image, fileName);
        FreeImage_Unload(image);
    }

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
                     "[clip]c[palettesize]i[globalpalette]b"
                     "[algorithm]s[globalpaletteoutputfile]s",
                     ColorQuantize::CreateColorQuantize, 0);
    return "`ColorQuantize' Reduce colors to a palette";
}
