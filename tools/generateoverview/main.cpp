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

// constants for parsing the Freemind XML
// the 'mm' prefix stands for MindMap
const QLatin1String mmClipTags("clip_tags");
const QLatin1String mmClipLength("clip_length");
const QLatin1String mmClipWidth("clip_width");
const QLatin1String mmClipHeight("clip_height");
const QLatin1String mmClipWidthHd("clip_width_hd");
const QLatin1String mmClipHeightHd("clip_height_hd");
const QLatin1String mmClipDefaultWidth("clip_default_width");
const QLatin1String mmClipDefaultHeight("clip_default_height");
const QLatin1String mmClipDefaultWidthHd("clip_default_width_hd");
const QLatin1String mmClipDefaultHeightHd("clip_default_height_hd");
const QLatin1String mmNode("node");
const QLatin1String mmRichContent("richcontent");
const QLatin1String mmHtml("html");
const QLatin1String mmP("p");
const QLatin1String mmText("TEXT");
const QLatin1String mmName("NAME");
const QLatin1String mmValue("VALUE");
const QLatin1String mmAttribute("attribute");
const QLatin1String mmYoutubeId("youtube_id");
const QLatin1String mmYoutubeIdHd("youtube_id_hd");

struct Root;
struct Category;

struct Clip {
    QString title;
    QStringList description;
    QStringList tags;
    QString length;
    QString youtubeID;
    QString youtubeIDHd;
    QSize clipSize;
    QSize clipSizeHd;
    Category *category;

    static Clip *createClip(QXmlStreamReader &reader, Category *category);
    QString html() const;
    QString jsData() const
    {
        QStringList segments;
        const QString tmplate = QLatin1String("%1: %2, %3: %4, %5: '%6'");
        if (!youtubeID.isEmpty())
            segments.append(tmplate
                            .arg(mmClipWidth).arg(size().width())
                            .arg(mmClipHeight).arg(size().height())
                            .arg(mmYoutubeId).arg(youtubeID));
        if (!youtubeIDHd.isEmpty())
            segments.append(tmplate
                            .arg(mmClipWidthHd).arg(sizeHd().width())
                            .arg(mmClipHeightHd).arg(sizeHd().height())
                            .arg(mmYoutubeIdHd).arg(youtubeIDHd));
        return QLatin1String("{")
                + segments.join(QLatin1String(", "))
                + QLatin1String("}");
    }
    bool publishable() const
    {
        return !(youtubeID.isEmpty() && youtubeIDHd.isEmpty());
    }
    QSize size() const;
    QSize sizeHd() const;

private:
    Clip()
        : category(0)
    {
    }

    Root *root() const;
};

struct Category {
    QString title;
    QStringList description;
    QStringList tags;
    QList <Clip*> clips;
    Root *root;

    static Category *createCategory(QXmlStreamReader &reader, Root *root);
    ~Category()
    {
        qDeleteAll(clips);
    }

    QString html() const;
    bool publishable() const
    {
        foreach (const Clip *clip, clips)
            if (clip->publishable())
                return true;
        return false;
    }

private:
    Category()
        : root(0)
    {
    }
};

struct Root {
    QStringList description;
    QStringList tags;
    QList <Category*> categories;
    mutable int indentationLength;
    bool publishing;
    QSize clipDefaultSize;
    QSize clipDefaultSizeHd;

    static Root *createRoot(QXmlStreamReader &reader);
    ~Root()
    {
        qDeleteAll(categories);
    }

    QString html() const;

    QString indentation() const
    {
        return QString(indentationLength, QLatin1Char('\t'));
    }

    void increaseIndentation() const
    {
        indentationLength++;
    }

    void decreaseIndentation() const
    {
        indentationLength--;
        Q_ASSERT(indentationLength >= 0);
    }

private:
    Root()
        : indentationLength(0)
        , publishing(true)
    {
    }
};

Root *Clip::root() const
{
    return category->root;
}

QString Root::html() const
{
    QString result;
    result.append(QLatin1String("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\""
                                "\n  \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"));
    result.append(QLatin1String("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">\n"));
    increaseIndentation();
    result.append(indentation() + QLatin1String("<head>\n"));
    increaseIndentation();
    result.append(indentation() + QLatin1String("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>\n"));
    result.append(indentation() + QLatin1String("<meta name=\"language\" content=\"en\"/>\n"));
    result.append(indentation() + QLatin1String("<meta name=\"author\" content=\"Nokia, Qt Development Frameworks\"/>\n"));
    result.append(indentation() + QLatin1String("<meta name=\"description\" content=\"Qtorials - The bite sized Qt tutorial screencasts. First steps, fundamentals, and more, all in a not-too-boring fashion. Enjoy :)\"/>\n"));
    result.append(indentation() + QLatin1String("<meta name=\"keywords\" content=\"Tutorials, Qtorials, Qt, Software, Development, Screen casts, Open source, Nokia\"/>\n"));
    result.append(indentation() + QLatin1String("<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" media=\"screen\"/>\n"));
    result.append(indentation() + QLatin1String("<link rel=\"stylesheet\" type=\"text/css\" href=\"fancybox/jquery.fancybox-1.2.6.css\" media=\"screen\"/>\n"));
    result.append(indentation() + QLatin1String("<title>Qtorials - Bite sized Qt tutorials</title>\n"));
    result.append(indentation() + QLatin1String("<script type=\"text/javascript\" src=\"jquery-1.3.2.min.js\"></script>\n"));
    result.append(indentation() + QLatin1String("<script type=\"text/javascript\" src=\"fancybox/jquery.fancybox-1.2.6.min.js\"></script>\n"));
    result.append(indentation() + QLatin1String("<script type=\"text/javascript\" src=\"script.js\"></script>\n"));
    result.append(indentation() + QLatin1String("<script type=\"text/javascript\">\n"));
    increaseIndentation();
    {
        result.append(indentation() + QLatin1String("var qtorialsData = {\"clips\": [\n"));
        increaseIndentation();
        bool firstClip = true;
        foreach (const Category *category, categories)
            foreach (const Clip *clip, category->clips)
                if (!publishing || clip->publishable()) {
                    if (firstClip)
                        firstClip = false;
                    else
                        result.append(QLatin1String(",\n"));
                    result.append(indentation() + clip->jsData());
                }
        result.append(QLatin1String("\n"));
        decreaseIndentation();
        result.append(indentation() + QLatin1String("]};\n"));
    }
    decreaseIndentation();
    result.append(indentation() + QLatin1String("</script>\n"));
    decreaseIndentation();
    result.append(indentation() + QLatin1String("</head>\n"));
    result.append(indentation() + QLatin1String("<body>\n"));
    increaseIndentation();
    result.append(indentation() + QLatin1String("<h1>Qtorials</h1>\n"));
    result.append(indentation() + QLatin1String("<ul id=\"qtorials\">\n"));
    increaseIndentation();
    foreach (const Category *category, categories) {
        if (!publishing || category->publishable())
            result.append(category->html());
    }
    decreaseIndentation();
    result.append(indentation() + QLatin1String("</ul>\n"));
    decreaseIndentation();
    result.append(indentation() + QLatin1String("</body>\n"));
    decreaseIndentation();
    result.append(QLatin1String("</html>\n"));
    return result;
}

QString Category::html() const
{
    QString result;
    result.append(root->indentation() + QLatin1String("<li>\n"));
    root->increaseIndentation();
    result.append(root->indentation() + QLatin1String("<h2>") + title + QLatin1String("</h2>\n"));
    result.append(root->indentation()
                  + QLatin1String("<p>")
                  + description.join(QLatin1String("</p>\n<p>"))
                  + QLatin1String("</p>\n"));
    result.append(root->indentation() + QLatin1String("<ul>\n"));
    root->increaseIndentation();
    foreach (const Clip *clip, clips) {
        if (!root->publishing || clip->publishable())
            result.append(clip->html());
    }
    root->decreaseIndentation();
    result.append(root->indentation() + QLatin1String("</ul>\n"));
    result.append(root->indentation() + QLatin1String("<span class=\"clearomator\">&nbsp;</span><!-- Hack to keep floating things inside content area -->\n"));
    root->decreaseIndentation();
    result.append(root->indentation() + QLatin1String("</li>\n"));
    return result;
}

QString inYouTubeLink(const QString &youTubeID, const QString &innerHtml)
{
    return QString::fromLatin1("<a href=\"http://youtube.com/watch?v=%1\">%2</a>")
                  .arg(youTubeID).arg(innerHtml);
}

QString Clip::html() const
{
    QString result;
    const QString completeTitle =
            category->title + QLatin1String(" - ") + title;
    result.append(root()->indentation() + QLatin1String("<li>\n"));
    root()->increaseIndentation();
    const bool useHDClip = youtubeID.isEmpty();
    const QString defaultYouTubeID = useHDClip ? youtubeIDHd : youtubeID;
    const QString thumbnailImage =
            QString::fromLatin1("<img src=\"http://img.youtube.com/vi/%1/default.jpg\" alt=\"%2\" width=\"%3\" height=\"%4\"/>")
            .arg(defaultYouTubeID).arg(completeTitle).arg(120).arg(90);
    result.append(root()->indentation()
                  + inYouTubeLink(defaultYouTubeID, thumbnailImage)
                  + QLatin1String("\n"));
    result.append(root()->indentation()
                  + QLatin1String("<h3>")
                  + (root()->publishing ? title : completeTitle)
                  + QLatin1String("</h3>\n"));
    result.append(root()->indentation()
                  + QLatin1String("<p>")
                  + description.join(QLatin1String("</p>\n<p>"))
                  + QLatin1String("</p>\n"));
    result.append(root()->indentation() + QLatin1String("<ul>\n"));
    root()->increaseIndentation();
    result.append(root()->indentation()
                  + QLatin1String("<li class=\"cliplength\">")
                  + length
                  + QLatin1String("</li>\n"));
    if (!youtubeID.isEmpty())
        result.append(root()->indentation()
                      + QLatin1String("<li class=\"watchclip\">")
                      + inYouTubeLink(youtubeID, QLatin1String("Watch"))
                      + QLatin1String("</li>\n"));
    if (!youtubeIDHd.isEmpty())
        result.append(root()->indentation()
                      + QLatin1String("<li class=\"watchclip\">")
                      + inYouTubeLink(youtubeIDHd, QLatin1String("Watch (HD)"))
                      + QLatin1String("</li>\n"));
    root()->decreaseIndentation();
    result.append(root()->indentation() + QLatin1String("</ul>\n"));
    if (!root()->publishing)
        result.append(root()->indentation()
                      + QLatin1String("<span class=\"tags\">")
                      + (tags + category->tags + root()->tags).join(QLatin1String(", "))
                      + QLatin1String("</span>\n"));
    root()->decreaseIndentation();
    result.append(root()->indentation() + QLatin1String("</li>\n"));
    return result;
}

QStringList readRichContentParagraphs(QXmlStreamReader &reader)
{
    QStringList result;
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::Characters:
            if (!reader.isWhitespace())
                result.append(reader.text().toString().trimmed());
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == mmHtml)
                return result;
            break;
        default:
            break;
        }
    }
    return result;
}

QStringList splittedTags(const QString &tagsCsv)
{
    QStringList result;
    foreach (const QString &tag, tagsCsv.split(QLatin1Char(','), QString::SkipEmptyParts))
        result.append(tag.trimmed());
    return result;
}

Clip *Clip::createClip(QXmlStreamReader &reader, Category *category)
{
    Clip *clip = new Clip;
    clip->category = category;
    if (reader.attributes().hasAttribute(mmText))
        clip->title = reader.attributes().value(mmText).toString();
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == mmRichContent) {
                clip->description = readRichContentParagraphs(reader);
            } else if (reader.name() == mmAttribute) {
                if (reader.attributes().value(mmName) == mmYoutubeId)
                    clip->youtubeID = reader.attributes().value(mmValue).toString();
                else if (reader.attributes().value(mmName) == mmYoutubeIdHd)
                    clip->youtubeIDHd = reader.attributes().value(mmValue).toString();
                else if (reader.attributes().value(mmName) == mmClipTags)
                    clip->tags = splittedTags(reader.attributes().value(mmValue).toString());
                else if (reader.attributes().value(mmName) == mmClipLength)
                    clip->length = reader.attributes().value(mmValue).toString();
                else if (reader.attributes().value(mmName) == mmClipWidth)
                    clip->clipSize.setWidth(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipHeight)
                    clip->clipSize.setHeight(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipWidthHd)
                    clip->clipSizeHd.setWidth(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipHeightHd)
                    clip->clipSizeHd.setHeight(reader.attributes().value(mmValue).toString().toInt());
            }
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == mmNode)
                return clip;
            break;
        default:
            break;
        }
    }
    return clip;
}

QSize Clip::size() const
{
    return QSize(
            clipSize.width() > 0 ? clipSize.width() : root()->clipDefaultSize.width(),
            clipSize.height() > 0 ? clipSize.height() : root()->clipDefaultSize.height());
}

QSize Clip::sizeHd() const
{
    return QSize(
            clipSizeHd.width() > 0 ? clipSizeHd.width() : root()->clipDefaultSizeHd.width(),
            clipSizeHd.height() > 0 ? clipSizeHd.height() : root()->clipDefaultSizeHd.height());
}

Category *Category::createCategory(QXmlStreamReader &reader, Root *root)
{
    Category *category = new Category;
    category->root = root;
    if (reader.attributes().hasAttribute(mmText))
        category->title = reader.attributes().value(mmText).toString();
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == mmNode) {
                category->clips.append(Clip::createClip(reader, category));
            } else if (reader.name() == mmRichContent) {
                category->description = readRichContentParagraphs(reader);
            } else if (reader.name() == mmAttribute) {
                if (reader.attributes().value(mmName) == mmClipTags)
                    category->tags = splittedTags(reader.attributes().value(mmValue).toString());
            }
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == mmNode)
                return category;
            break;
        default:
            break;
        }
    }
    return category;
}

Root *Root::createRoot(QXmlStreamReader &reader)
{
    Root *root = new Root;
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == mmNode) {
                root->categories.append(Category::createCategory(reader, root));
            } else if (reader.name() == mmRichContent) {
                root->description = readRichContentParagraphs(reader);
            } else if (reader.name() == mmAttribute) {
                if (reader.attributes().value(mmName) == mmClipTags)
                    root->tags = splittedTags(reader.attributes().value(mmValue).toString());
                else if (reader.attributes().value(mmName) == mmClipDefaultWidth)
                    root->clipDefaultSize.setWidth(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipDefaultHeight)
                    root->clipDefaultSize.setHeight(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipDefaultWidthHd)
                    root->clipDefaultSizeHd.setWidth(reader.attributes().value(mmValue).toString().toInt());
                else if (reader.attributes().value(mmName) == mmClipDefaultHeightHd)
                    root->clipDefaultSizeHd.setHeight(reader.attributes().value(mmValue).toString().toInt());
            }
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == mmNode)
                return root;
            break;
        default:
            break;
        }
    }
    Q_ASSERT(root->clipDefaultSize.isValid());
    Q_ASSERT(root->clipDefaultSizeHd.isValid());
    return root;
}

int main(int argc, char *argv[])
{
    const QString mmFileName = QLatin1String((argc >= 2) ?
                                             argv[1]
                                             : "../../overview/qtorials.mm");
    QFile mmFile(mmFileName);
    if (!mmFile.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot open '%s' for reading.", mmFileName.toLocal8Bit().data());
        return 1;
    }

    const QString htmlFileName = QLatin1String((argc >= 3) ?
                                               argv[2]
                                               : "../../overview/html/index.html");
    QFile htmlFile(htmlFileName);
    if (!htmlFile.open(QFile::WriteOnly)) {
        fprintf(stderr, "Cannot open '%s' for writing.", htmlFileName.toLocal8Bit().data());
        return 2;
    }

    Root *root = 0;
    QXmlStreamReader reader(&mmFile);
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == mmNode) {
                Q_ASSERT(!root);
                root = Root::createRoot(reader);
            }
            break;
        default:
            break;
        }
    }

    htmlFile.write(root->html()
                   .remove(QLatin1Char('\n')).remove(QLatin1Char('\t'))
                   .toUtf8());

    const QString htmlDetailsFileName = QLatin1String("../../overview/html/index_details.html");
    QFile htmlDetailsFile(htmlDetailsFileName);
    if (!htmlDetailsFile.open(QFile::WriteOnly)) {
        fprintf(stderr, "Cannot open '%s' for writing.", htmlDetailsFileName.toLocal8Bit().data());
        return 3;
    }
    root->publishing = false;
    htmlDetailsFile.write(root->html()
                          .remove(QLatin1Char('\n')).remove(QLatin1Char('\t'))
                          .toUtf8());

    delete root;

    return 0;
}
