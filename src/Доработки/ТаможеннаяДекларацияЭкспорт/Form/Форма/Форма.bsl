﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем ГенераторТестовыхДанных;
&НаКлиенте
Перем ЗапросыИзБД;
&НаКлиенте
Перем УтвержденияПроверкаТаблиц;
&НаКлиенте
Перем РаботаСДокументами;

&НаКлиенте
Перем Форма;

#Область ЮнитТестирование

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
	РаботаСДокументами = КонтекстЯдра.Плагин("Plugin_РаботаСДокументами");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("ФормаРабочееМесто");
	НаборТестов.Добавить("ФормаДокумента");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаТеста() Экспорт
	
	Попытка
		Форма.Модифицированность = Ложь;
		Форма.Закрыть();
	Исключение
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ФормаРабочееМесто() Экспорт
	
	Форма = ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаРабочееМесто");
	
КонецПроцедуры	

&НаКлиенте
Процедура ФормаДокумента() Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ПолучитьДокумент());
	
	Форма = ОткрытьФорму("Документ.ТаможеннаяДекларацияЭкспорт.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьДокумент()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТаможеннаяДекларацияЭкспорт.Ссылка
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт КАК ТаможеннаяДекларацияЭкспорт
	|ГДЕ
	|	ТаможеннаяДекларацияЭкспорт.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаможеннаяДекларацияЭкспорт.Дата УБЫВ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Документы.ТаможеннаяДекларацияЭкспорт.ПустаяСсылка();
	Иначе	
		Возврат Результат.Выгрузить()[0].Ссылка;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Функция ПолучитьМакет(ИмяМакета = "Данные")
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	
КонецФункции
