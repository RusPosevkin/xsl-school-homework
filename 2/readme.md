Задание 2. Обработка данных.

Пусть у вас есть база данных Audio-CD в  xml-файле, содержащая для каждого
CD-диска следующую информацию:
- год;
- артист;
- студия;
- список треков;
- ссылка на обложку.

Задание:

Написать xsl-шаблон, который на выходе создает html со списком CD-дисков,
удовлетворяющих заданным входным требования. Требования задаютия как параметры
запуска xsltproc.

Требования/параметры могут быть такими:
а. Параметр year — вывести все альбомы, выпущенные в заданном году (по умолчанию
не задан);
б. Параметр sort — поле сортировки (варианты — исполнитель, название альбома, год,
студия; по умолчанию — имя исполнителя);
в. Параметр order — прямое или обратное направление сортировки (по умолчанию — прямой);
г. Парамаетр artist — вывести все альбомы заданного исполнителя.
-----
Запуск.

Допустимые значения для параметра «sort»: "artist" | "name" | "year" | "label"
Допустимые значения для параметра «order»: "ascending" | "descending"

xsltproc --param artist "'50 Cent'" --param year "'2010'" --output out.html audio-cd.xsl audio-cd.xml

xsltproc --param artist "'50 Cent'" --output out.html audio-cd.xsl audio-cd.xml

xsltproc --param sort "'artist'" --output out.html audio-cd.xsl audio-cd.xml

msxsl.exe audio-cd.xml audio-cd.xsl -o output.html year="2010"
msxsl.exe audio-cd.xml audio-cd.xsl -o output.html artist="50 Cent"

Все параметры можно указать одновременно в одном запросе.

msxsl.exe audio-cd.xml audio-cd.xsl -o output.html year="2010" artist="50 Cent" sort="name" order="descending"
