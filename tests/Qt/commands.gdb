# Load common test helper functions
source ../test_helpers.gdb

# Run until the end 
break main.cpp:132

# Run the program
run

# ---------------------------------------------------------
# Test Cases
# ---------------------------------------------------------

# QString
python check("str", r'"Hello, Qt!"')

# QByteArray
python check("byteArray", r'"Qt QByteArray"')

# QChar
python check("character", r'"Q"')

# FIXME
# QJsonArray: size 3
# Python Exception <class 'RuntimeError'> Qt version too old for inspecting QJsonArray:
# python check("jsonArray", r'QJsonArray \(size = 3\)')

# FIXME
# QJsonObject: size 2
# Python Exception <class 'RuntimeError'> Qt version too old for inspecting QJsonObject:
# python check("jsonObject", r'QJsonObject \(size = 2\)')

# QLatin1String / QLatin1StringView
python check("latin1String", r'"Latin1"')

# QList<QString>
python check("stringListInQList", r'QList<QString> \(size = 3\)')

# QMap
python check("map", r'QMap<QString, int> \(size = 3\)')

# QHash
python check("hash", r'QHash<QString, QString> \(size = 2\)')

# QQueue
python check("queue", r'QQueue<int> \(size = 3\)')

# QSet
python check("set", r'QSet<QString> \(size = 3\)')

# QStack
python check("stack", r'QStack<QString> \(size = 3\)')

# QString (Multi-byte)
python check("str2", r'\"你好，Qt\"')

# QStringList
python check("qStringList", r'QStringList<QString> \(size = 3\)')

# QVariant
python check("variantInt", r'QVariant\(int, 42\)')
python check("variantString", r'QVariant\(QString, \"variant\"\)')
python check("variantUrl", r'QVariant\(QUrl,.*\)')

# QVariantMap
python check("variantMap", r'QMap<QString, QVariant> \(size = 2\)')

# QVariantList
python check("variantList", r'QList<QVariant> \(size = 4\)')

# QVector
python check("vector", r'QVector<double> \(size = 3\)')

# QUrl
python check("url", r'https://qt\.io')

# QUuid
python check("uuid", r'QUuid\(\{12345678-1234-1234-1234-123456789abc\}\)')

# --- Conditional Checks ---
# We use python to check existence or just try/except in the check function

# QLinkedList (Qt5 only)
python check("linkedList", r'QLinkedList<int> \(size = 3\)|No symbol')

# QDate (Regex for current date is hard, just check format YYYY-MM-DD or valid)
python check("date", r'\d{4}-\d{2}-\d{2}')

# QDateTime
python check("dateTime", r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')

# QTime
python check("time", r'\d{2}:\d{2}:\d{2}')

# QTimeZone
python check("timeZoneUtc", r'UTC')
python check("timeZoneLocal", r'fTC[+-]\d{2}:\d{2}|Local|[A-Za-z]+/[A-Za-z_]+')

quit
