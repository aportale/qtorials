#include "windows.h"
#include "avisynth.h"

class TimeLapse : public IClip
{
public:
    TimeLapse(PClip originClip, int lapseFactor, int primaryFrameWeight)
        : m_origin(originClip)
        , m_lapseFactor(lapseFactor)
        , m_primaryFrameWeight(primaryFrameWeight)
        , m_targetVideoInfo(originClip->GetVideoInfo())
    {
        m_targetVideoInfo.num_frames =
                m_targetVideoInfo.num_frames / lapseFactor;
        m_targetVideoInfo.audio_samples_per_second = 0;
    }

    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env)
    {
        PVideoFrame dst = env->NewVideoFrame(m_targetVideoInfo);
        unsigned char* const dstp = dst->GetWritePtr();
        const size_t sumFieldsCount = dst->GetRowSize() * dst->GetHeight();
        unsigned int * const sum = new unsigned int[sumFieldsCount];
        memset(sum, 0, sumFieldsCount * sizeof(unsigned int));
        for (int i = 0; i < m_lapseFactor; ++i) {
            const PVideoFrame src =
                    m_origin->GetFrame(n * m_lapseFactor + i, env);
            const unsigned char* const srcp = src->GetReadPtr();
            const unsigned int valueFactor =
                    (i + 1 == m_lapseFactor) ? m_primaryFrameWeight : 1;
            for (unsigned int j = 0; j < sumFieldsCount; ++j)
                sum[j] += (srcp[j] * valueFactor);
        }
        const unsigned int divisor = m_lapseFactor + m_primaryFrameWeight - 1;
        for (unsigned int i = 0; i < sumFieldsCount; ++i)
            dstp[i] = sum[i] / divisor;
        delete [] sum;
        return dst;
    }

    static AVSValue __cdecl CreateTimeLapse(AVSValue args, void* /* user_data */,
                                           IScriptEnvironment* env)
    {
        PClip origin = args[0].AsClip();
        const int lapseFactor = args[1].AsInt(2);
        const int primaryframeweight = args[2].AsInt(1);

        const int mimumLapseFactor = 2;
        if (lapseFactor < mimumLapseFactor)
            env->ThrowError("TimeLapse: Invalid lapsefactor %d.\n"
                            "The minimum value is %d."
                            , lapseFactor, mimumLapseFactor);

        const int originFrames = origin->GetVideoInfo().num_frames;
        if (lapseFactor > originFrames)
            env->ThrowError("TimeLapse: Invalid lapsefactor %d.\n"
                            "The input clip has %d frames which is"
                            "the minimum value for lapsefactor."
                            , lapseFactor, originFrames);

        return new TimeLapse(origin, lapseFactor, primaryframeweight);
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

    void __stdcall GetAudio(void* /* buf */, __int64 /* start */, __int64 /* count */,
                                      IScriptEnvironment* /* env */)
    {
    }

protected:
    PClip m_origin;
    int m_lapseFactor;
    int m_primaryFrameWeight;
    VideoInfo m_targetVideoInfo;
};

extern "C" __declspec(dllexport)
const char* __stdcall AvisynthPluginInit2(IScriptEnvironment* env)
{
    env->AddFunction("TimeLapse",
                     "[clip]c[lapsefactor]i[primaryframeweight]i",
                     TimeLapse::CreateTimeLapse, 0);
    return "`TimeLapse' Time lapse with blended frames";
}
