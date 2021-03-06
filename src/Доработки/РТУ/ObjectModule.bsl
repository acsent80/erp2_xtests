﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

Перем РаботаСДокументами;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
	РаботаСДокументами = КонтекстЯдра.Плагин("Plugin_РаботаСДокументами");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.Добавить("ТОРГ12");
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ТОРГ12() Экспорт
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	РаботаСДокументами.УдалитьДокументыПоОрганизации(СтруктураДанных.Организация);
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	
	РаботаСДокументами.ПровестиДокумент(СтруктураДанных.ПоступлениеТоваровУслуг1);
	РаботаСДокументами.ПровестиДокумент(СтруктураДанных.РеализацияТоваровУслуг1);
	
	ТОРГ12Оригинал = ПолучитьМакет("ТОРГ12");
	ТабДок = СформироватьПечФормуТОРГ12(СтруктураДанных.РеализацияТоваровУслуг1);
	
	УтвержденияПроверкаТаблиц.ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТОРГ12Оригинал, ТабДок,,, "Не верная печ. форма ТОРГ-12");
	
КонецПроцедуры

Функция СформироватьПечФормуТОРГ12(Ссылка)
	
	СтруктраТипов = Новый Соответствие;
	
	Массив = Новый Массив;
	Массив.Добавить(Ссылка);
	
	СтруктраТипов.Вставить("Документ.РеализацияТоваровУслуг", Массив);
	
	ОбъектыПечати = Новый СписокЗначений;
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ВыводитьУслуги", Истина);
	
	Возврат Обработки.ПечатьОбщихФорм.СформироватьПечатнуюФормуТОРГ12(СтруктраТипов, ОбъектыПечати, ПараметрыПечати);
	
КонецФункции
