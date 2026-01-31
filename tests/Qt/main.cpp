#include <QCoreApplication>
#include <QDebug>
#include <QBitArray>
#include <QByteArray>
#include <QChar>
#include <QDate>
#include <QDateTime>
#include <QHash>
#include <QJsonArray>
#include <QJsonObject>
#include <QList>
#include <QMap>
#include <QQueue>
#include <QSet>
#include <QStack>
#include <QString>
#include <QStringList>
#include <QTime>
#include <QTimeZone>
#include <QUrl>
#include <QVarLengthArray>
#include <QVariant>
#include <QVariantList>
#include <QVariantMap>
#include <QVector>
#include <QUuid>

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    #include <QLatin1String>
    #include <QLinkedList>
#else
    #include <QLatin1StringView>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QString str = "Hello, Qt!";

    QBitArray bitArray(5);
    bitArray.setBit(0);
    bitArray.setBit(3);

    QByteArray byteArray = "Qt QByteArray";

    QChar character = 'Q';

    QDate date = QDate::currentDate();

    QDateTime dateTime = QDateTime::currentDateTime();

    QJsonArray jsonArray;
    jsonArray.append("Qt");
    jsonArray.append(5);
    jsonArray.append(true);

    QJsonObject jsonObject;
    jsonObject.insert("name", "Qt");
    jsonObject.insert("version", 5.15);

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QLatin1String latin1String("Latin1");
#else
    QLatin1StringView latin1String("Latin1");
#endif

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QLinkedList<int> linkedList;
    linkedList << 10 << 20 << 30;
#endif

   QList<QString> stringListInQList;
    stringListInQList << QStringLiteral("alpha") << QStringLiteral("beta") << QStringLiteral("gamma");

    QMap<QString, int> map;
    map.insert(QStringLiteral("one"), 1);
    map.insert(QStringLiteral("two"), 2);
    map.insert(QStringLiteral("three"), 3);

    QHash<QString, QString> hash;
    hash.insert(QStringLiteral("language"), QStringLiteral("C++"));
    hash.insert(QStringLiteral("framework"), QStringLiteral("Qt"));

    QQueue<int> queue;
    queue.enqueue(100);
    queue.enqueue(200);
    queue.enqueue(300);

    QSet<QString> set;
    set.insert(QStringLiteral("red"));
    set.insert(QStringLiteral("green"));
    set.insert(QStringLiteral("blue"));

    QStack<QString> stack;
    stack.push(QStringLiteral("first"));
    stack.push(QStringLiteral("second"));
    stack.push(QStringLiteral("third"));

    QString str2 = QStringLiteral("你好，Qt");

    QStringList qStringList;
    qStringList << QStringLiteral("a") << QStringLiteral("b") << QStringLiteral("c");

    QTime time = QTime::currentTime();

    QTimeZone timeZoneUtc = QTimeZone::utc();
    QTimeZone timeZoneLocal = QTimeZone::systemTimeZone();

    QVariant variantInt = 42;
    QVariant variantString = QStringLiteral("variant");
    QVariant variantUrl = QUrl(QStringLiteral("https://example.com"));

    QVariantMap variantMap;
    variantMap.insert(QStringLiteral("answer"), 42);
    variantMap.insert(QStringLiteral("message"), QStringLiteral("hello"));

    QVariantList variantList;
    variantList << 1 << 2 << 3 << QStringLiteral("four");

    QVector<double> vector;
    vector << 3.14 << 2.718 << 1.618;

    QUrl url(QStringLiteral("https://qt.io"));

    QUuid uuid("{12345678-1234-1234-1234-123456789abc}");

    QVarLengthArray<int, 8> varLengthArray;
    varLengthArray.append(7);
    varLengthArray.append(8);
    varLengthArray.append(9);

    return 0; 
}
