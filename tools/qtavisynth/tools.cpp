#include "tools.h"
#include "painting.h"

#include <QGuiApplication>
#include <QFileInfo>
#include <QThread>

#include <future>
#include <mutex>
#include <thread>

#ifdef Q_OS_WIN
#include <qt_windows.h>
#endif

const int Tools::defaultClipWidth = 640;
const int Tools::defaultClipHeight = 480;

QString Tools::cleanFileName(const QString &file)
{
    const QString cleanFilePath = QFileInfo(file).canonicalFilePath();
    return cleanFilePath.isEmpty() ? file : cleanFilePath;
}

void Tools::checkSvgAndThrow(const QString &svgFileName,
                             const QString &svgElement,
                             IScriptEnvironment* env)
{
    const Painting::SvgResult result =
            Painting::checkSvg(svgFileName, svgElement);
    switch (result) {
        case Painting::SvgFileNotValid:
                env->ThrowError("Svg: File '%s' was not found or is invalid SVG.",
                                svgFileName.toLatin1().data());
        case Painting::SvgElementNotFound:
                env->ThrowError("Svg: Svg element '%s' was not found.",
                                svgElement.toLatin1().data());
        case Painting::SvgOk:
            break;
    }
}

PClip Tools::rgbOverlay(const PClip &backgroundClip, const PClip &overlayClip,
                        IScriptEnvironment* env)
{
    if (!backgroundClip)
        return overlayClip;

    const PClip showAlpha = env->Invoke("ShowAlpha", overlayClip).AsClip();
    const AVSValue params[] = { backgroundClip, overlayClip, 0, 0, showAlpha };
    const AVSValue paramsValue = AVSValue(params, sizeof params / sizeof params[0]);
    return env->Invoke("Overlay", paramsValue).AsClip();
}

static char *argv[] = {(char*)"."};
static int argc = sizeof(argv) / sizeof(argv[0]);

// The thread in which the application object created by the plugin lives
static std::thread *applicationThread = nullptr;

// Qt needs an application object for fonts, text rendering and QML. The host application
// (VirtualDub, mpv, ...) is usually no Qt application, so the plugin creates one when the
// first QtAviSynth filter is created. AviSynth+ calls filters from the thread that evaluates
// the script, and with Prefetch() from its worker threads, none of which runs a Qt event
// loop. So the application gets a thread of its own that runs one, and the QML rendering
// happens there (see runInApplicationThread()).
// The application is never deleted: AviSynth+ runs IScriptEnvironment::AtExit callbacks before
// it destroys the clips held in script variables, and filters may render frames until then.
void Tools::createQGuiApplicationIfNeeded()
{
    static std::once_flag once;
    std::call_once(once, [] {
        if (QCoreApplication::instance())
            return; // Belongs to the host application

        std::promise<void> created;
        std::future<void> isCreated = created.get_future();
        applicationThread = new std::thread([created = std::move(created)]() mutable {
            auto application = new QGuiApplication(argc, argv);
            application->setQuitOnLastWindowClosed(false);
            created.set_value();
            application->exec();
        });
        isCreated.wait();
    });
}

// Runs function in the thread of the application object and waits for it to finish
void Tools::runInApplicationThread(const std::function<void()> &function)
{
    QCoreApplication *application = QCoreApplication::instance();
    if (application->thread()->isCurrentThread()) {
        function();
        return;
    }

#ifdef Q_OS_WIN
    // At process exit, Windows terminates all other threads before it unloads the DLLs. A
    // filter that is destroyed during the unloading would then wait forever.
    if (applicationThread
            && WaitForSingleObject(applicationThread->native_handle(), 0) == WAIT_OBJECT_0)
        return;
#endif

    QMetaObject::invokeMethod(application, function, Qt::BlockingQueuedConnection);
}
