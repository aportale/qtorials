#pragma once

#include <QImage>
#include <QMutex>
#include <QObject>
#include <QSize>
#include <QStringList>
#include <QVariantMap>

#include "avisynth.h"
#include "sourcefilter.h"

QT_FORWARD_DECLARE_CLASS(QQmlComponent)
QT_FORWARD_DECLARE_CLASS(QQmlEngine)
QT_FORWARD_DECLARE_CLASS(QQuickItem)
QT_FORWARD_DECLARE_CLASS(QQuickRenderControl)
QT_FORWARD_DECLARE_CLASS(QQuickWindow)
QT_FORWARD_DECLARE_CLASS(QRhiRenderBuffer)
QT_FORWARD_DECLARE_CLASS(QRhiRenderPassDescriptor)
QT_FORWARD_DECLARE_CLASS(QRhiTexture)
QT_FORWARD_DECLARE_CLASS(QRhiTextureRenderTarget)

class QmlAnimationRenderer : public QObject
{
    Q_OBJECT

public:
    explicit QmlAnimationRenderer(bool useGpu);
    ~QmlAnimationRenderer() override;

    // These run in the application thread, see Tools::runInApplicationThread().
    // initialize() returns an error message, or an empty string on success.
    QString initialize(const QString &mainQmlFile, const QStringList &importPaths,
                       const QVariantMap &initialProperties);
    void renderFrame();

    QSize m_size;
    bool m_useGpu = true;
    double m_timelineAnimationDuration = -1;
    double m_timeLineStartFrame = -1;
    double m_timeLineEndFrame = -1;
    QQuickItem *m_rootItem = nullptr;
    QObject *m_timeLineItem = nullptr;
    QQmlEngine *m_qmlEngine = nullptr;
    QQmlComponent *m_qmlComponent = nullptr;
    QQuickWindow *m_quickWindow = nullptr;
    QQuickRenderControl *m_renderControl = nullptr;
    // Render target of the GPU backends
    QRhiTexture *m_texture = nullptr;
    QRhiRenderBuffer *m_depthStencil = nullptr;
    QRhiTextureRenderTarget *m_renderTarget = nullptr;
    QRhiRenderPassDescriptor *m_renderPassDescriptor = nullptr;

    QImage m_softwareImage; // Render target of the software backend
    QImage m_frame;
    double m_frameN = -1;
};

class QmlAnimation : public SourceFilter
{
public:
    QmlAnimation(const QString &qmlFile, double fps, const QString &initialProperties,
                 bool useGpu, IScriptEnvironment *env);
    PVideoFrame __stdcall GetFrame(int n, IScriptEnvironment* env) override;
    static AVSValue __cdecl CreateQmlAnimation(AVSValue args, void* user_data,
                                               IScriptEnvironment* env);
private:
    QmlAnimationRenderer m_renderer;
    QMutex m_mutex; // GetFrame() may be called from several threads at once
};
