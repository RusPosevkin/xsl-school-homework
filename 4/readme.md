Задание 4. Генерация меню.
На страницах сайта часто нужно размещать меню, представляющее собой список ссылок.
Текущий выбранный элемент меню отображается без ссылки.

Задание:

а. Написать xsl-шаблон для генерации html-кода элемента меню, который на вход принимает 
один параметр с типом nodeset и заданной структурой:
<xsl:param name="menu" select="/.." />
@@param nodeset  $menu    описание блока меню

Описание каждого элемента в $menu/item:

string $menu/item/title		заголовок элемента меню
string $menu/item/url		адрес ссылки элемента меню
string [$menu/item/@is-current=false()]		признак, что этот пункт меню активен

б. Пусть есть следующий xml в качестве источника данных:

<root>
	<!-- информация о текущем запросе пользователя -->
	<request>
		<host>mysite.com</host>
		<url>/about</url>
	</request>
	<!-- структура проекта -->
	<project>
		<page name="Главная">/</page>
		<page name="Каталог">/catalog</page>
		<page name="О нас">/about</page>
		<page name="Контакты">/contacts</page>
	</project>
</root>
Необходимо из данных составить nodeset, который принимает шаблон меню, и отрисовать блок, вызвав шаблон.
----- 
Запуск

xsltproc --output out.html menu.xsl menu.xml

-----
Первым шагом формируется временное дерево, представленное в следующем виде:
<menu>
	<item>
		<title>Главная</title>
		<url>mysite.com/</url>
	</item>
	<item>
		<title>Каталог</title>
		<url>mysite.com/catalog</url>
	</item>
	<item is-current="true">
		<title>О нас</title>
		<url>mysite.com/about</url>
	</item>
	<item>
		<title>Контакты</title>
		<url>mysite.com/contacts</url>
	</item>
</menu>

Далее дерево преобразуется в html-разметку.


