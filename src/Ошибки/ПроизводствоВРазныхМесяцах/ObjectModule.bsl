﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	//Тест проверяет распределение материалов на заказы, у которых МЛ есть в разных месяцах
	//В типовой такая ситуация вдет к появлению незавершенки
	
	НаборТестов.Добавить("ПроизводствоВРазныхМесяцах");
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ПроизводствоВРазныхМесяцах() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	УдалитьДокументы(Структура.Организация);
	
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	ПровестиДокументы(СтруктураДанных);
	
	ЗакрытьМесяц(Структура.Организация);
	
КонецПроцедуры

Процедура УдалитьДокументы(Организация)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	Таблица.Колонки.Добавить("Отбор");
	
	ДобавитьДокумент(Таблица, "Документ.РасчетСебестоимостиТоваров");
	ДобавитьДокумент(Таблица, "Документ.РегламентнаяОперация");
	ДобавитьДокумент(Таблица, "Документ.ПереоценкаВалютныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученныйАванс");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданный");
	ДобавитьДокумент(Таблица, "Документ.ВзаимозачетЗадолженности");
	ДобавитьДокумент(Таблица, "Документ.РеализацияТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.АктВыполненныхРабот");
	ДобавитьДокумент(Таблица, "Документ.ЗаказКлиента");
	ДобавитьДокумент(Таблица, "Документ.РаспределениеПроизводственныхЗатрат");
	ДобавитьДокумент(Таблица, "Документ.СборкаТоваров");
	ДобавитьДокумент(Таблица, "Документ.ВыпускПродукции");
	ДобавитьДокумент(Таблица, "Документ.ПередачаМатериаловВПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ПеремещениеТоваров");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПеремещение");
	ДобавитьДокумент(Таблица, "Документ.МаршрутныйЛистПроизводства");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученный");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеУслугПрочихАктивов");
	ДобавитьДокумент(Таблица, "Документ.ЗаказПоставщику");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.АвансовыйОтчет КАК Док
	|ГДЕ
	|	Док.Организация = &Организация";
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Текст1 = СтрЗаменить(ТекстЗапроса, "Документ.АвансовыйОтчет", СтрокаТЗ.Имя);
		Текст1 = СтрЗаменить(Текст1, "Док.Организация", СтрокаТЗ.Отбор);
		
		Запрос.Текст = Текст1;
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		УдалитьОбъектыИзТаблицы(ТаблицаДокументов);
		
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ПровестиДокументы(СтруктураДанных)
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводство.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ЗаказНаПроизводство
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства1
	
	ДокументОбъект = СтруктураДанных.МаршрутныйЛистПроизводства2.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //МаршрутныйЛистПроизводства2
	
	ДокументОбъект = СтруктураДанных.ВыпускПродукции1.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ВыпускПродукции1
	
	ДокументОбъект = СтруктураДанных.ВыпускПродукции2.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ВыпускПродукции2
	
	ДокументОбъект = СтруктураДанных.ПоступлениеТоваровИУслуг.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ПоступлениеТоваровИУслуг
	
	ДокументОбъект = СтруктураДанных.ПередачаМатериаловВПроизводство.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //ПередачаМатериаловВПроизводство
	
	ДокументОбъект = СтруктураДанных.РаспределениеМатериаловИРабот.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); //РаспределениеМатериаловИРабот
	
КонецПроцедуры	

Функция ПолучитьПараметрыРасчета(Организация = Неопределено)

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если Организация = Неопределено Тогда
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПараметрыЗакрытия.ЗакрываемыйПериод
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК ПараметрыЗакрытия
	|ГДЕ
	|	ПараметрыЗакрытия.Организация = &Организация
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	ЗакрываемыйПериод = Дата("00010101000000");
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗакрываемыйПериод = ВыборкаДетальныеЗаписи.ЗакрываемыйПериод;
	КонецЦикла;
	
	СписокОрганизаций = Новый Массив();
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций.Добавить(Организация);
	КонецЕсли;
	
	МассивОпераций = Новый Массив();
	//++ НЕ УТ
	Для Каждого Значение Из Перечисления.ТипыРегламентныхОпераций Цикл
		Если Значение <> Перечисления.ТипыРегламентныхОпераций.ЗакрытиеГода Тогда
			МассивОпераций.Добавить(Значение);
		ИначеЕсли КонецМесяца(ЗакрываемыйПериод) = КонецГода(ЗакрываемыйПериод) Тогда // надо закрыть год
			МассивОпераций.Добавить(ЗакрываемыйПериод);
		КонецЕсли;
	КонецЦикла;
	//-- НЕ УТ
	
	ПараметрыРасчета = Новый Структура("СписокОрганизаций, Организация, ПериодРегистрации, Период, МассивОпераций, АдресХранилища");
	ПараметрыРасчета.СписокОрганизаций = СписокОрганизаций;
	ПараметрыРасчета.Организация = Организация;
	ПараметрыРасчета.ПериодРегистрации = ЗакрываемыйПериод;
	ПараметрыРасчета.Период = ЗакрываемыйПериод;
	ПараметрыРасчета.МассивОпераций = МассивОпераций;
	ПараметрыРасчета.АдресХранилища = Неопределено;
	
	Возврат ПараметрыРасчета;
	//ЗакрытиеМесяцаУТВызовСервера.РассчитатьВФоновомЗадании(ПараметрыРасчета);
	
КонецФункции

Процедура ЗакрытьМесяц(Организация)
	
	Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
	Запись.ЗакрываемыйПериод = '2016-01-01';
	Запись.Организация       = Организация;
	Запись.Период            = ТекущаяДата();
	Запись.Записать();
	
	ПараметрыРасчета = ПолучитьПараметрыРасчета(Организация);
	ЗакрытиеМесяцаУТВызовСервера.РассчитатьЭтапы(ПараметрыРасчета);
	
	Результат = ПартииНезавершенногоПроизводства(Организация, '2016-02-01');
	Утверждения.ПроверитьИстину (Результат, "Обнаружены остатки по регистру ПартииНезавершенногоПроизводства")
	//Ожидаем.Что(Результат).ЭтоИстина();
	
КонецПроцедуры	

&НаСервере
Функция ПартииНезавершенногоПроизводства(Организация, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Период",      Дата);
	Запрос.Параметры.Вставить("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.ВидЗапасов,
	|	Рег.ЗаказНаПроизводство,
	|	Рег.КодСтрокиПродукция,
	|	Рег.ДокументПоступления,
	|	Рег.Этап,
	|	Рег.СтатьяКалькуляции,
	|	Рег.АналитикаУчетаПартий,
	|	Рег.КоличествоОстаток КАК Количество,
	|	Рег.СтоимостьОстаток КАК Стоимость,
	|	Рег.СтоимостьБезНДСОстаток КАК СтоимостьБезНДС,
	|	Рег.СтоимостьРеглОстаток КАК СтоимостьРегл,
	|	Рег.НДСРеглОстаток КАК НДСРегл,
	|	Рег.ПостояннаяРазницаОстаток КАК ПостояннаяРазница,
	|	Рег.ВременнаяРазницаОстаток КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПартииНезавершенногоПроизводства.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

Процедура ДобавитьДокумент(Таблица, Имя, Отбор = "Организация")
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Имя   = Имя;
	НоваяСтрока.Отбор = Отбор;
	
КонецПроцедуры	

Функция УдалитьОбъектыИзТаблицы(Таблица)
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		УдалитьОбъект(СтрокаТЗ.Ссылка);
		
	КонецЦикла;	
	
КонецФункции	

Функция УдалитьОбъект(Ссылка)
	
	Объект = Ссылка.ПолучитьОбъект();
	
	Если Объект <> Неопределено Тогда
		
		Попытка
			Объект.Удалить();
		Исключение
			//Сообщить(Строка(ТипЗнч(Объект)) + ": " + Строка(Объект));
		КонецПопытки;
		
	КонецЕсли;	
	
КонецФункции	

