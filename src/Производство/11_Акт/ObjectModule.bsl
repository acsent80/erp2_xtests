﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

Перем СтруктураДанных;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
	СтруктураДанных = ПолучитьСтруктуруДанных();
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("АктКС2");
	НаборТестов.Добавить("АктКС2_РегУчет");
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

Функция ДобавитьВСтруктуруДействияПриИзмененииКоличества(СтруктураДействий, Объект)
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать, ИмяКоличества", Ложь, "Количество"));
	СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
	СтруктураДействий.Вставить("ОчиститьСуммуВзаиморасчетов");
	СтруктураДействий.Вставить("ПересчитатьСумму", "Количество");
	
КонецФункции

Процедура АктКС2() Экспорт
	
	ДокументОбъект = СтруктураДанных.Акт.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

Процедура АктКС2_РегУчет() Экспорт
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктураДанных.Акт, "Дата, Организация");
	
	СтруктураРеквизиты = Новый Структура("Ссылка, Дата, Организация", СтруктураДанных.Акт, РеквизитыДокумента.Дата, РеквизитыДокумента.Организация);
	РеглУчетПроведениеСервер.ОтразитьДокумент(СтруктураРеквизиты, Истина);
	
КонецПроцедуры	
	

Функция ПолучитьСтруктуруДанных()
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	
	Возврат Структура;
	
КонецФункции




