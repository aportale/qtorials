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

const QLatin1String clipTags("clip_tags");
const QLatin1String node("node");
const QLatin1String richContent("richcontent");
const QLatin1String html("html");
const QLatin1String p("p");
const QLatin1String text("TEXT");

struct Root;
struct Category;

struct Clip {
    QString title;
    QStringList description;
    QStringList tags;
    QTime length;
    QString youtubeID;
    Category *category;

    QString html() const;
};

struct Category {
    QString title;
    QStringList description;
    QStringList tags;
    QList <Clip*> clips;
    Root *root;

    ~Category()
    {
        qDeleteAll(clips);
    }
    QString html() const;
};

struct Root {
    QStringList description;
    QStringList tags;
    QList <Category*> categories;

    ~Root()
    {
        qDeleteAll(categories);
    }
    QString html() const;
};

QString Root::html() const
{
    QString result;
    result.append(QLatin1String("<h1>Qtorials<h1>\n"));
    foreach (const Category *category, categories) {
        result.append(category->html());
    }
    return result;
}

QString Category::html() const
{
    QString result;
    result.append(QLatin1String("<h2>") + title + QLatin1String("<h2>\n"));
    foreach (const Clip *clip, clips) {
        result.append(clip->html());
    }
    return result;
}

QString Clip::html() const
{
    QString result;
    result.append(QLatin1String("<h3>")
                  + category->title
                  + QLatin1String(" - ")
                  + title
                  + QLatin1String("<h3>\n"));
    result.append(QLatin1String("<p>")
                  + description.join(QLatin1String("</p>\n<p>"))
                  + QLatin1String("</p>\n"));
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
            if (reader.name() == html)
                return result;
            break;
        default:
            break;
        }
    }
    return result;
}

Clip *readClip(QXmlStreamReader &reader)
{
    Clip *clip = new Clip;
    if (reader.attributes().hasAttribute(text))
        clip->title = reader.attributes().value(text).toString();
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == richContent)
                clip->description = readRichContentParagraphs(reader);
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == node)
                return clip;
            break;
        default:
            break;
        }
    }
    return clip;
}

Category *readCategory(QXmlStreamReader &reader)
{
    Category *category = new Category;
    if (reader.attributes().hasAttribute(text))
        category->title = reader.attributes().value(text).toString();
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == node) {
                Clip *clip = readClip(reader);
                clip->category = category;
                category->clips.append(clip);
            } else if (reader.name() == richContent) {
                category->description = readRichContentParagraphs(reader);
            }
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == node)
                return category;
            break;
        default:
            break;
        }
    }
    return category;
}

Root *readRoot(QXmlStreamReader &reader)
{
    Root *root = new Root;
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == node) {
                Category *category = readCategory(reader);
                category->root = root;
                root->categories.append(category);
            } else if (reader.name() == richContent) {
                root->description = readRichContentParagraphs(reader);
            }
            break;
        case QXmlStreamReader::EndElement:
            if (reader.name() == node)
                return root;
            break;
        default:
            break;
        }
    }
    return root;
}

int main(int argc, char *argv[])
{
    QString mmFileName;
    mmFileName = QLatin1String((argc >= 2) ?
                               argv[1]
                               : "../../concepts/qtorials.mm");

    QFile mmFile(mmFileName);
    if (!mmFile.open(QIODevice::ReadOnly)) {
        fprintf(stderr, "Cannot open '%s'", mmFileName.toLocal8Bit().data());
        return 1;
    }

    Root *root = 0;
    QXmlStreamReader reader(&mmFile);
    while (!reader.atEnd()) {
        const QXmlStreamReader::TokenType token = reader.readNext();
        switch (token) {
        case QXmlStreamReader::StartElement:
            if (reader.name() == node) {
                Q_ASSERT(!root);
                root = readRoot(reader);
            }
            break;
        default:
            break;
        }
    }
    qDebug() << root->html();

    delete root;

    return 0;
}
