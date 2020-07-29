#pragma once

#include <QQmlComponent>
#include <QQmlEngine>

#include "avisynth.h"

QT_FORWARD_DECLARE_CLASS(QOpenGLContext)
QT_FORWARD_DECLARE_CLASS(QOpenGLFramebufferObject)
QT_FORWARD_DECLARE_CLASS(QOffscreenSurface)
QT_FORWARD_DECLARE_CLASS(QQuickWindow)
QT_FORWARD_DECLARE_CLASS(QQuickRenderControl)

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
    QQuickWindow *m_quickWindow;

    QOpenGLContext *m_openGLContext;
    QOpenGLFramebufferObject *m_openGLFramebufferObject;
    QOffscreenSurface *m_offscreenSurface;
    QQuickRenderControl *m_renderControl;
};
