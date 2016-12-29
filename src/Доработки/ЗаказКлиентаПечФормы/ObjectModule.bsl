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
	НаборТестов.Добавить("Инвойс_ENG");
	НаборТестов.Добавить("PackingList_ENG");
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура Инвойс_ENG() Экспорт
	
	Макет = ПолучитьМакет("Ссылки");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет);
	УдалитьДокументыПоОрганизации(СтруктураДанных.Организация);
	
	Макет = ПолучитьМакет("Данные");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет);
	
	ПровестиДокумент(СтруктураДанных.ЗаказКлиента1);
	
	ТабОригинал = ПолучитьМакет("Инвойс_ENG");
	ТабДокумент = Печать(СтруктураДанных.ЗаказКлиента1, "Инвойс_ENG");
	
	УтвержденияПроверкаТаблиц.ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТабОригинал, ТабДокумент,, "Не совпал результат");
		
КонецПроцедуры	

Процедура PackingList_ENG() Экспорт
	
	Макет = ПолучитьМакет("Ссылки");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет);
	УдалитьДокументыПоОрганизации(СтруктураДанных.Организация);
	
	Макет = ПолучитьМакет("Данные");
	СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоТабличномуДокументу(Макет);
	
	ПровестиДокумент(СтруктураДанных.ЗаказКлиента1);
	
	ТабОригинал = ПолучитьМакет("PackingList_ENG");
	ТабДокумент = Печать(СтруктураДанных.ЗаказКлиента1, "PackingList_ENG");
	
	УтвержденияПроверкаТаблиц.ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТабОригинал, ТабДокумент,, "Не совпал результат");
		
КонецПроцедуры	

Функция Печать(Ссылка, Идентификатор)
	
	ИсточникДанных = ПолучитьИсточникДанных(Идентификатор);
	
	ОбъектыНазначения = Новый Массив;
	ОбъектыНазначения.Добавить(Ссылка);
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ИдентификаторКоманды", Идентификатор);	
	ПараметрыИсточника.Вставить("ОбъектыНазначения",    ОбъектыНазначения);	
	
	Результат       = Неопределено;
	ОбъектыПечати   = Новый СписокЗначений;
	ПараметрыВывода = Неопределено;
	
	ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(ИсточникДанных,
		ПараметрыИсточника, Результат, ОбъектыПечати, ПараметрыВывода);
		
	Возврат Результат[0].ТабличныйДокумент;	
	
КонецФункции	

Функция ПолучитьИсточникДанных(Знач Идентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрКоманды.Ссылка
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки.Команды КАК СпрКоманды
	|ГДЕ
	|	СпрКоманды.Идентификатор = &Идентификатор
	|	И СпрКоманды.Ссылка.Вид = &Вид
	|	И НЕ СпрКоманды.Ссылка.ПометкаУдаления";
	
	Запрос.Параметры.Вставить("Идентификатор", Идентификатор);
	Запрос.Параметры.Вставить("Вид",           Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ВызватьИсключение "Не найдна печ. форма " + Идентификатор;
	КонецЕсли;	
	
	Возврат Результат.Выгрузить()[0].Ссылка;

КонецФункции

Процедура ПровестиДокумент(Ссылка)
	
	ДокументОбъект = Ссылка.ПолучитьОбъект();
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры	

#Область УдалениеДокументов

Процедура УдалитьДокументыПоОрганизации(Организация)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	Таблица.Колонки.Добавить("Отбор");
	
	//ДобавитьДокумент(Таблица, "Документ.РасчетСебестоимостиТоваров");
	//ДобавитьДокумент(Таблица, "Документ.РегламентнаяОперация");
	//ДобавитьДокумент(Таблица, "Документ.ПереоценкаВалютныхСредств");
	//ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	//ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученныйАванс");
	//ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданный");
	//ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданныйАванс");
	//ДобавитьДокумент(Таблица, "Документ.ВзаимозачетЗадолженности");
	//ДобавитьДокумент(Таблица, "Документ.РеализацияТоваровУслуг");
	//ДобавитьДокумент(Таблица, "Документ.СписаниеБезналичныхДенежныхСредств");
	//ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	//ДобавитьДокумент(Таблица, "Документ.АктВыполненныхРабот");
	//ДобавитьДокумент(Таблица, "Документ.РаспределениеПроизводственныхЗатрат");
	//ДобавитьДокумент(Таблица, "Документ.СборкаТоваров");
	//ДобавитьДокумент(Таблица, "Документ.ВыработкаСотрудников");
	//ДобавитьДокумент(Таблица, "Документ.ВыпускПродукции");
	//ДобавитьДокумент(Таблица, "Документ.ПередачаМатериаловВПроизводство");
	//ДобавитьДокумент(Таблица, "Документ.ПеремещениеТоваров");
	//ДобавитьДокумент(Таблица, "Документ.ЗаказНаПеремещение");
	//ДобавитьДокумент(Таблица, "Документ.МаршрутныйЛистПроизводства");
	//ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученный");
	//ДобавитьДокумент(Таблица, "Документ.ПоступлениеТоваровУслуг");
	//ДобавитьДокумент(Таблица, "Документ.ПоступлениеУслугПрочихАктивов");
	//ДобавитьДокумент(Таблица, "Документ.ПриемНаРаботу");
	//ДобавитьДокумент(Таблица, "Документ.НачислениеЗарплаты");
	//ДобавитьДокумент(Таблица, "Документ.ОтражениеЗарплатыВФинансовомУчете");
	//ДобавитьДокумент(Таблица, "Документ.КорректировкаЗаказаМатериаловВПроизводство");
	//ДобавитьДокумент(Таблица, "Документ.ЗаказНаПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ЗаказКлиента");
	
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
		Для каждого Строка1 из ТаблицаДокументов Цикл
			
			ДокументОбъект = Строка1.Ссылка.ПолучитьОбъект();
			
			Если ДокументОбъект <> Неопределено Тогда
				
				Попытка
					ДокументОбъект.Удалить();
				Исключение
					//Сообщить(Строка(ТипЗнч(Объект)) + ": " + Строка(Объект));
				КонецПопытки;
				
			КонецЕсли;	
					
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ДобавитьДокумент(Таблица, Имя, Отбор = "Организация")
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Имя   = Имя;
	НоваяСтрока.Отбор = Отбор;
	
КонецПроцедуры	

#КонецОбласти
