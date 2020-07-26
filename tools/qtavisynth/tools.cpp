#include "tools.h"
#include "filters.h"

#include <QGuiApplication>
#include <QFileInfo>

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
    const Filters::SvgResult result =
            Filters::checkSvg(svgFileName, svgElement);
    switch (result) {
        case Filters::SvgFileNotValid:
                env->ThrowError("Svg: File '%s' was not found or is invalid SVG.",
                                svgFileName.toLatin1().data());
        case Filters::SvgElementNotFound:
                env->ThrowError("Svg: Svg element '%s' was not found.",
                                svgElement.toLatin1().data());
        case Filters::SvgOk:
            break;
    }
}

PClip Tools::rgbOverlay(const PClip &backgroundClip, const PClip &overlayClip,
                        IScriptEnvironment* env)
{
    const PClip showAlpha = env->Invoke("ShowAlpha", overlayClip).AsClip();
    const AVSValue params[] = { backgroundClip, overlayClip, 0, 0, showAlpha };
    const AVSValue paramsValue = AVSValue(params, sizeof params / sizeof params[0]);
    return env->Invoke("Overlay", paramsValue).AsClip();
}

static char *argv[] = {(char*)"."};
static int argc = sizeof(argv) / sizeof(argv[0]);

QGuiApplication* Tools::createQGuiApplicationIfNeeded()
{
    return qGuiApp ? nullptr : new QGuiApplication(argc, argv);
}

void Tools::deleteQGuiApplicationIfNeeded(QGuiApplication *&app)
{
    return; // TODO: find out whether deleting the application is needed
    if (app) {
        delete app;
        app = nullptr;
    }
}
