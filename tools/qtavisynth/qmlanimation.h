#pragma once

#include <QQmlComponent>
#include <QQmlEngine>

#include "avisynth.h"

QT_FORWARD_DECLARE_CLASS(QQuickWindow)
QT_FORWARD_DECLARE_CLASS(QQuickRenderControl)

class QmlAnimation : public GenericVideoFilter
{
public:
    QmlAnimation(PClip background, const QString &qmlFile, IScriptEnvironment *env);
    ~QmlAnimation() override;
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    const QString m_qmlFile;
    QQmlEngine *m_qmlEngine;
    QQmlComponent *m_qmlComponent;
    QQuickWindow *m_quickWindow;
    QQuickRenderControl *m_renderControl;
};
