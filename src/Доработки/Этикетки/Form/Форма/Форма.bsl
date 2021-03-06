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
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("ДоступностьРеквизитовСерия");
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
Процедура ДоступностьРеквизитовСерия() Экспорт
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Назначение", ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Форма = ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников", ПараметрыФормы);
	
	ЕстьНоменклатура   = Ложь;
	ЕстьХарактеристика = Ложь;
	ЕстьНазначение     = Ложь;
	
	Для каждого Строка1 из Форма.ДоступныеПоляКомпоновкиДанных.ПолучитьЭлементы() Цикл
		
		Если Строка1.Описание = "Номенклатура" Тогда
			ЕстьНоменклатура   = Истина;
		ИначеЕсли Строка1.Описание = "Характеристика" Тогда
			ЕстьХарактеристика = Истина;
		ИначеЕсли Строка1.Описание = "Назначение" Тогда
			ЕстьНазначение     = Истина;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Утверждения.ПроверитьРавенство(ЕстьНоменклатура,   Истина, "Нет номенклатуры");
	Утверждения.ПроверитьРавенство(ЕстьХарактеристика, Истина, "Нет характеристики");
	Утверждения.ПроверитьРавенство(ЕстьНазначение,     Истина, "Нет назначения");
	
КонецПроцедуры

