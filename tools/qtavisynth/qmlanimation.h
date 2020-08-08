#pragma once

#include <QQmlComponent>
#include <QQmlEngine>

#include "avisynth.h"

QT_FORWARD_DECLARE_CLASS(QQuickItem)
QT_FORWARD_DECLARE_CLASS(QOpenGLContext)
QT_FORWARD_DECLARE_CLASS(QOpenGLFramebufferObject)
QT_FORWARD_DECLARE_CLASS(QOffscreenSurface)
QT_FORWARD_DECLARE_CLASS(QQuickWindow)
QT_FORWARD_DECLARE_CLASS(QQuickRenderControl)

class QmlAnimation : public GenericVideoFilter
{
public:
    QmlAnimation(PClip background, const QString &qmlFile, const QString &parameters,
                 bool useOpenGL, IScriptEnvironment *env);
    ~QmlAnimation() override;
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    double m_timelineAnimationDuration = -1;
    double m_timeLineStartFrame = -1;
    double m_timeLineEndFrame = -1;
    QQuickItem *m_rootItem = nullptr;
    QObject *m_timeLineItem = nullptr;
    QQmlEngine *m_qmlEngine = nullptr;
    QQmlComponent *m_qmlComponent = nullptr;
    QQuickWindow *m_quickWindow = nullptr;
    QQuickRenderControl *m_renderControl = nullptr;
    QOpenGLContext *m_openGLContext = nullptr;
    QOpenGLFramebufferObject *m_openGLFramebufferObject = nullptr;
    QOffscreenSurface *m_offscreenSurface = nullptr;
    bool m_useOpenGL = true;
};
