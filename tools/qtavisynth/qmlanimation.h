#pragma once

#include <QQmlComponent>
#include <QQuickItem>
#include <QQuickWindow>

#include "avisynth.h"

class QmlAnimation : public GenericVideoFilter
{
public:
    QmlAnimation(PClip background, const QString &qmlFile);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    const QString m_qmlFile;
};
