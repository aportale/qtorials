#pragma once

#include <QQmlComponent>
#include <QQmlEngine>
#include <QImage>
#include <QSize>

#include "avisynth.h"

QT_FORWARD_DECLARE_CLASS(QQuickItem)
QT_FORWARD_DECLARE_CLASS(QOpenGLContext)
QT_FORWARD_DECLARE_CLASS(QOpenGLFramebufferObject)
QT_FORWARD_DECLARE_CLASS(QOffscreenSurface)
QT_FORWARD_DECLARE_CLASS(QQuickWindow)
QT_FORWARD_DECLARE_CLASS(QQuickRenderControl)

class QmlAnimationRenderer : public QObject
{
    Q_OBJECT

public:
    QmlAnimationRenderer(const QString &qmlFile, const QString &initialProperties, const QSize &size,
                         bool useOpenGL, IScriptEnvironment *env);
    ~QmlAnimationRenderer() override;

    void renderFrame();

    const QSize m_size;
    bool m_useOpenGL = true;
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

    QImage m_frame;
    int m_frameN = -1;
};

class QmlAnimation : public GenericVideoFilter
{
public:
    QmlAnimation(PClip background, const QString &qmlFile, const QString &initialProperties,
                 bool useOpenGL, IScriptEnvironment *env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);

private:
    QmlAnimationRenderer m_renderer;
};
