#pragma once

#include <QQmlComponent>
#include <QQmlEngine>

#include "avisynth.h"

class QmlAnimation : public GenericVideoFilter
{
public:
    QmlAnimation(PClip background, const QString &qmlFile, IScriptEnvironment *env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    const QString m_qmlFile;
    QQmlEngine m_qmlEngine;
    QPointer<QQmlComponent> m_qmlComponent;
};
