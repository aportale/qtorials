/*
    This work is licensed under the Creative Commons
    Attribution-Noncommercial-Share Alike 3.0 Unported
    License. To view a copy of this license, visit
    http://creativecommons.org/licenses/by-nc-sa/3.0/
    or send a letter to Creative Commons,
    171 Second Street, Suite 300, San Francisco,
    California, 94105, USA.
*/

#include <QtCore>

static const QString narrationMarker = QLatin1String("#n ");
static const QString typingMarker = QLatin1String("#t ");
static const QString functionKeyword = QLatin1String("function ");

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Please provide one .avs file");
        return 1;
    }

    QFile avsFile(argv[1]);
    if (!avsFile.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot open '%s'", argv[1]);
        return 2;
    }
    QTextStream avsTs(&avsFile);

    const QFileInfo avsFInfo(avsFile);
    const QString filesBasePathAndName =
        avsFInfo.absolutePath() + QDir::separator() + avsFInfo.baseName();
    QFile au3File(filesBasePathAndName + QLatin1String(".au3"));
    QFile htmlFile(filesBasePathAndName + QLatin1String(".html"));
    if (!au3File.open(QIODevice::WriteOnly) || !htmlFile.open(QIODevice::WriteOnly)) {
        fprintf(stderr, "Cannot create '%s'", argv[1]);
        return 2;
    }
    QTextStream au3Ts(&au3File);
    QTextStream htmlTs(&htmlFile);

    au3Ts <<
        "#include <Array.au3>\n\n"
        "Opt(\"SendKeyDelay\", 80)\n"
        "HotKeySet(\"{F8}\", \"Terminate\")\n"
        "HotKeySet(\"{F9}\", \"TypeSnippet\")\n\n"
        "Local $snippetsArray[1]\n"
        "$snippetsLineIndex = 1\n\n"
        "Func Terminate()\n"
        "    Exit 0\n"
        "EndFunc\n\n"
        "Func TypeSnippet()\n"
        "    For $snippetPiece IN StringSplit($snippetsArray[$snippetsLineIndex], '§', 2)\n"
        "        Send($snippetPiece)\n"
        "        Sleep(350)\n"
        "    Next\n"
        "    $snippetsLineIndex = $snippetsLineIndex + 1\n"
        "    If $snippetsLineIndex = UBound($snippetsArray) Then\n"
        "        Exit 0\n"
        "    EndIf\n"
        "EndFunc\n\n";

    QString avsLine;
    QString hmtlLines;
    QStringList narrationLines;
    bool changedAvsFunction = false;
    do {
        avsLine = avsTs.readLine();
        if (avsLine.trimmed().startsWith(narrationMarker)) {
            if (changedAvsFunction) {
                htmlTs << QLatin1String("<hr/>\n");
                changedAvsFunction = false;
            }
            const int markerEnd =
                avsLine.indexOf(narrationMarker) + narrationMarker.length();
            narrationLines << avsLine.mid(markerEnd);
        } else {
            if (!narrationLines.isEmpty()) {
                htmlTs << QLatin1String("<p>\n");
                htmlTs << narrationLines.join(QLatin1String("\n<br/>\n"));
                htmlTs << QLatin1String("\n</p>\n");
                narrationLines.clear();
            }
        }
        if (avsLine.trimmed().startsWith(typingMarker)) {
            const int markerEnd =
                avsLine.indexOf(typingMarker) + typingMarker.length();
            au3Ts << "_ArrayAdd($snippetsArray, '" << avsLine.mid(markerEnd) << "')" << endl;
        } else if (avsLine.trimmed().toLower().startsWith(functionKeyword)) {
            changedAvsFunction = true;
        }
    } while (!avsLine.isNull());

    au3Ts <<
        "\nWhile 1\n"
        "    Sleep(100)\n"
        "WEnd\n";

    return 0;
}
