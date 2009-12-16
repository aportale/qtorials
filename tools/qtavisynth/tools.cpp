#include "tools.h"
#include "filters.h"
#include <QFileInfo>

const int Tools::defaultClipWidth = 640;
const int Tools::defaultClipHeight = 480;
const QRgb Tools::transparentColor = qRgba(0x00, 0x00, 0x00, 0x00);

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
                env->ThrowError("Svg: File '%s'' was not found or is invalid SVG.",
                                svgFileName.toAscii().data());
            break;
        case Filters::SvgElementNotFound:
                env->ThrowError("Svg: Svg element '%s' was not found.",
                                svgElement.toAscii().data());
            break;
        default:
            break;
    }
}
