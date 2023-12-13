﻿
&НаКлиенте
Процедура ЗаполнитьОтбор(Команда)

	Если Не ПустаяСтрока(Окна) Тогда
		Форма = НайтиОкноПоУникальномуИдентификатору(Окна);
		ЗагрузитьОтборВОтчет(Форма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокНоменклатуры(Артикулы)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Артикул В(&Артикулы)";
	Запрос.УстановитьПараметр("Артикулы", Артикулы);
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	
КонецФункции

&НаКлиенте
Процедура ПолучитьОкнаПриложения(Команда)
	Перем Окно;
	Окна = ПолучитьОкна();
	Для каждого Окно Из Окна Цикл
		Если Окно.Начальнаястраница Тогда
			Продолжить;
		КонецЕсли;
		Если СтрНачинаетсяС(Окно.Заголовок, "Обороты счета") Тогда
			Для каждого Форма Из Окно.Содержимое Цикл
				Если СтрНачинаетсяС(Форма.ИмяФормы, "Отчет.") тогда
					Форма.Элементы.РазделыОтчета.ТекущаяСтраница = Форма.Элементы.НастройкиОтчета;
				КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОкнаКоманда(Команда)
	ОбновитьОкна();
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьОкна()
	Перем Окно, Окна;
	Элементы.Окна.СписокВыбора.Очистить();
	СписокОкон = Элементы.Окна.СписокВыбора;

	ЗагрузитьСписокОкон(Элементы.Окна.СписокВыбора);
		
	Если СписокОкон.Количество() > 0 Тогда
		ЭтаФорма.Окна = СписокОкон[0].Значение;
		ОбновитьОтборыПриИзмененииВыбранногоОкна();
		Элементы.КомпоновщикНастроекНастройкиОтбор.ТекущаяСтрока = 1;
		КомпоновщикНастроекНастройкиОтборПриАктивизацииСтроки(Элементы.КомпоновщикНастроекНастройкиОтбор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСписокОкон(СписокОкон)
	

	ОкнаПриложения = ПолучитьОкна();
	
	Для каждого ОкноПриложения Из ОкнаПриложения Цикл
		Для каждого Форма Из ОкноПриложения.Содержимое Цикл
			Если НЕ ЭтаФорма.УникальныйИдентификатор = Форма.УникальныйИдентификатор Тогда
				Если СтрНачинаетсяС(Форма.ИмяФормы, "Отчет.") Тогда
					СписокОкон.Добавить(Строка(Форма.УникальныйИдентификатор), ОкноПриложения.Заголовок);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВКомпоновщикНастроек(КомпоновщикНастроекФормы)
	Настройки = КомпоновщикНастроекФормы.ПолучитьНастройки();
	ИсточникДоступныхНастроек = КомпоновщикНастроекФормы.ПолучитьИсточникДоступныхНастроек();
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
КонецПроцедуры

&НаСервере
Процедура ОкнаПриИзмененииНаСервере(КомпоновщикНастроекФормы)
	ЗагрузитьВКомпоновщикНастроек(КомпоновщикНастроекФормы);
КонецПроцедуры

&НаКлиенте
Функция НайтиОкноПоУникальномуИдентификатору(УникальныйИдентификаторФормы)
	Если Не ПустаяСтрока(УникальныйИдентификатор) Тогда
		УникальныйИдентификаторОкна = Новый УникальныйИдентификатор(УникальныйИдентификатор);	
	КонецЕсли;
	ОкнаПриложения = ПолучитьОкна();
	
	Для каждого ОкноПриложения Из ОкнаПриложения Цикл

		Для каждого Форма Из ОкноПриложения.Содержимое Цикл
			Если НЕ ЭтаФорма.УникальныйИдентификатор = Форма.УникальныйИдентификатор Тогда
				Если Строка(Форма.УникальныйИдентификатор) = УникальныйИдентификаторФормы Тогда
					Если СтрНачинаетсяС(Форма.ИмяФормы, "Отчет.") Тогда
						Возврат Форма;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьОтборВОтчет(Форма)
	НастройкиКомпоновщикаНастроекФормы = Форма.Отчет.КомпоновщикНастроек.Настройки;
	ЭлементыОтбораФормы = НастройкиКомпоновщикаНастроекФормы.Отбор.Элементы;
	Форма.Элементы.РазделыОтчета.ТекущаяСтраница = Форма.Элементы.НастройкиОтчета;
	ЭлементыОтбораКомпоновщикаНастроек =  КомпоновщикНастроек.Настройки.Отбор.Элементы;
	Для каждого ЭлементОтбора Из ЭлементыОтбораКомпоновщикаНастроек Цикл
		Если ЭлементОтбора.Использование Тогда
			ИндексЭлемента = ЭлементыОтбораКомпоновщикаНастроек.Индекс(ЭлементОтбора);
			ЗаполнитьЗначенияСвойств(ЭлементыОтбораФормы[ИндексЭлемента], ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	Форма.Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновщикаНастроекФормы);
	Форма.Активизировать();
КонецПроцедуры


&НаКлиенте
Процедура ОкнаПриИзменении(Элемент)
	ОбновитьОтборыПриИзмененииВыбранногоОкна();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборыПриИзмененииВыбранногоОкна()
	Если ЗначениеЗаполнено(Окна) Тогда
		Форма = НайтиОкноПоУникальномуИдентификатору(Окна);
		Если Форма = Неопределено Тогда
			ПоказатьПредупреждение(,нСтр("ru='Окно не найдено, обновите список окон'", "ru"));
		Иначе
			Если СтрНачинаетсяС(Форма.ИмяФормы, "Отчет.") Тогда
				Попытка
					Форма.ИзменениеСхемыКомпоновкиДанныхНаСервере();
				Исключение
					ОбщегоНазначенияКлиент.СообщитьПользователю(нСтр("ru='Необходимо сформировать отчет для инициализации внутренних данных отчета'", "ru"));
					Форма.СформироватьОтчетНаСервере();
					Форма.ИзменениеСхемыКомпоновкиДанныхНаСервере();
				КонецПопытки;
				ОкнаПриИзмененииНаСервере(Форма.Отчет.КомпоновщикНастроек);	
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.КомпоновщикНастроекНастройкиОтбор.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ЛевоеЗначение <> Неопределено  Тогда
		ПравоеЗначение = ТекущиеДанные.ПравоеЗначение;
		//Если правое значение неопределено, значит необходимо найти тип среди доступных типов отбора

		Если ПравоеЗначение <> Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				МассивТипов = ПравоеЗначение.ТипЗначения.Типы();
			Иначе
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(ТипЗнч(ПравоеЗначение));
			КонецЕсли;
			ОписаниеТиповПравогоЗначения = Новый ОписаниеТипов(МассивТипов);
		Иначе
			ОписаниеТиповПравогоЗначения = КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ТекущиеДанные.ЛевоеЗначение).Тип;
		КонецЕсли;
		Если ОписаниеТиповПравогоЗначения <> Неопределено Тогда
			РеквизитыОтбора = РеквизитыПравогоЗначения(ОписаниеТиповПравогоЗначения);
			Элементы.Реквизиты.СписокВыбора.ЗагрузитьЗначения(РеквизитыОтбора);
			Если Элементы.Реквизиты.СписокВыбора.Количество() > 0 Тогда
				Реквизиты = Элементы.Реквизиты.СписокВыбора[0].Значение;
				Объект.ТабличныйДокумент.Область(1,1).Текст = Реквизиты;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыПравогоЗначения(ОписаниеТипов)
	
	ТипыОписанияТипов = ОписаниеТипов.Типы();
	Для каждого ТипОписанияТипов Из ТипыОписанияТипов Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипОписанияТипов);
		Если Не ОбъектМетаданных = Неопределено Тогда
			МассивРеквизитов = ИменаРеквизитовОбъектаМетаданных(ОбъектМетаданных);
		Иначе
			МассивРеквизитов = Новый Массив;
			МассивРеквизитов.Добавить("Значение");
		КонецЕсли;		
	КонецЦикла;

	Возврат МассивРеквизитов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТипыРеквизита(ТипЗначенияРеквизита)
	МассивТипов = Новый Массив;
	Для каждого ТипРеквизита Из ТипЗначенияРеквизита.Типы() Цикл
		МассивТипов.Добавить(ТипРеквизита);
	КонецЦикла;
	Возврат МассивТипов;
КонецФункции


&НаСервереБезКонтекста
Функция ИменаРеквизитовОбъектаМетаданных(Знач ОбъектМетаданных)
	
	МассивРеквизитов = РеквизитыОбъектаМетаданных(ОбъектМетаданных);
	ИменаРеквизитов = Новый Массив;
	Для каждого Реквизит Из МассивРеквизитов Цикл
		ИменаРеквизитов.Добавить(Реквизит.Имя);
	КонецЦикла;
	Возврат ИменаРеквизитов;

КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыОбъектаМетаданных(Знач ОбъектМетаданных)
	
	МассивРеквизитов = Новый Массив;
	// не отбирать документы и перечисления
	Для каждого СтандартныйРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		Если СтандартныйРеквизит.Имя = "Код" ИЛИ СтандартныйРеквизит.Имя = "Номер" 
			Или СтандартныйРеквизит.Имя = "Дата" Или СтандартныйРеквизит.Имя = "Наименование" Тогда
			МассивРеквизитов.Добавить(СтандартныйРеквизит);
		КонецЕсли;
	КонецЦикла;	
	
	ВсеТипыДокументов = Документы.ТипВсеСсылки();
	ВсеТипыПеречислений = Перечисления.ТипВсеСсылки();
	Для каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		Если Не Реквизит.Имя = "Ссылка" Тогда
			ОписаниеТипаРеквизита = Реквизит.Тип;
			ТипыРеквизита = ОписаниеТипаРеквизита.Типы();
			// не отбираем по реквизитам с типом документ и перечисление
			Если ТипыРеквизита.Количество() = 1 И (ВсеТипыДокументов.СодержитТип(ТипыРеквизита[0]) 
				ИЛИ ВсеТипыПеречислений.СодержитТип(ТипыРеквизита[0])) Тогда
				Продолжить;
			КонецЕсли;
			МассивРеквизитов.Добавить(Реквизит);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивРеквизитов;

КонецФункции

&НаСервереБезКонтекста
Функция ЭтоСсылочныйТип(ТипОбъекта)
	ЭтоСсылочныйТип =  Справочники.ТипВсеСсылки().СодержитТип(ТипОбъекта) 
	ИЛИ  Документы.ТипВсеСсылки().СодержитТип(ТипОбъекта)
	ИЛИ БизнесПроцессы.ТипВсеСсылки().СодержитТип(ТипОбъекта) 
	ИЛИ ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипОбъекта)
	ИЛИ ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипОбъекта) 
	ИЛИ ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(ТипОбъекта) 
	ИЛИ Задачи.ТипВсеСсылки().СодержитТип(ТипОбъекта)
	ИЛИ ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипОбъекта)		
	ИЛИ Перечисления.ТипВсеСсылки().СодержитТип(ТипОбъекта) ;
	Возврат ЭтоСсылочныйТип;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОсновноеПредставлениеОбъектаМетаданных(ВидОбъекта, ОбъектМетаданных)
	Если ВидОбъекта = "Справочник" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСправочника.ВВидеКода Тогда
			Возврат "Код";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	ИначеЕсли ВидОбъекта = "ПланВидовХарактеристик" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеВидаХарактеристики.ВВидеКода Тогда
			Возврат "Код";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	ИначеЕсли ВидОбъекта = "ПланСчетов" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСчета.ВВидеКода Тогда
			Возврат "Код";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	ИначеЕсли ВидОбъекта = "ПланВидовРасчета" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеВидаРасчета.ВВидеКода Тогда
			Возврат "Код";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	ИначеЕсли ВидОбъекта = "ПланОбмена" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеПланаОбмена.ВВидеКода Тогда
			Возврат "Код";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	ИначеЕсли ВидОбъекта = "Задача" Тогда
		Если ОбъектМетаданных.ОсновноеПредставление = Метаданные.СвойстваОбъектов.ОсновноеПредставлениеЗадачи.ВВидеНомера Тогда
			Возврат "Номер";
		Иначе
			Возврат "Наименование";
		КонецЕсли;
	КонецЕсли;
КонецФункции


&НаСервереБезКонтекста
Функция ЗначенияПоРеквизиту(ОписаниеТиповПравогоЗначения, ИмяРеквизита, ТабличныйДокумент)
	Если ОписаниеТиповПравогоЗначения <> Неопределено Тогда
		СписокЗначенийОтбора = Новый СписокЗначений;
		МассивЗначений = Новый Массив;
		Для Строка=2 По ТабличныйДокумент.ВысотаТаблицы Цикл
			МассивЗначений.Добавить(СокрЛП(ТабличныйДокумент.Область(Строка, 1).Текст));		
		КонецЦикла;	
		Запрос = Новый Запрос;
		ТекстыЗапроса = Новый Массив;		
		Для каждого ТипОтбора Из ОписаниеТиповПравогоЗначения.Типы() Цикл
			Если ЭтоСсылочныйТип(ТипОтбора) Тогда
				ВидОбъекта = ОбщегоНазначения.ВидОбъектаПоТипу(ТипОтбора);
				ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипОтбора);
				ТипОбъекта = ОбъектМетаданных.Имя;			
				РеквизитыОбъектаМетаданных = РеквизитыОбъектаМетаданных(ОбъектМетаданных);
				ИскомыйРеквизитОбъектаМетаданных = Неопределено;
				Для каждого РеквизитОбъектаМетаданных Из РеквизитыОбъектаМетаданных Цикл
					Если РеквизитОбъектаМетаданных.Имя = ИмяРеквизита Тогда
						ИскомыйРеквизитОбъектаМетаданных = РеквизитОбъектаМетаданных;
						Прервать;
					КонецЕсли;
				КонецЦикла;

				ТипыРеквизита = ИскомыйРеквизитОбъектаМетаданных.Тип.Типы();
				Для каждого ТипОтбора Из ТипыРеквизита Цикл
					ЭтоСсылочныйТип = ЭтоСсылочныйТип(ТипОтбора);
					ТекстЗапроса = 
					"ВЫБРАТЬ
					|	%Таблица%.Ссылка КАК %Реквизит%
					|ИЗ
					|	%ВидОбъекта%.%ТипОбъекта% КАК %Таблица%
					|ГДЕ
					|	%ТипОбъекта%.%Реквизит%%.Наименование% В(&МассивЗначений)";
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Таблица%", ТипОбъекта);
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Реквизит%", ИмяРеквизита);
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ВидОбъекта%", ВидОбъекта);
					ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%ТипОбъекта%", ТипОбъекта);
					Если ЭтоСсылочныйТип Тогда
						ВидОбъектаРеквизита = ОбщегоНазначения.ВидОбъектаПоТипу(ТипОтбора);
						ОсновноеПредставление = "Наименование";
						ОбъектМетаданныхТипа = Метаданные.НайтиПоТипу(ТипОтбора);
						Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданныхТипа, "ОсновноеПредставление") Тогда
							ОсновноеПредставление = ОсновноеПредставлениеОбъектаМетаданных(ВидОбъектаРеквизита, ОбъектМетаданныхТипа);
						КонецЕсли;
						ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%.Наименование%", "." + ОсновноеПредставление);
					Иначе
						ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%.Наименование%", "");
					КонецЕсли;
					ТекстыЗапроса.Добавить(ТекстЗапроса);
				КонецЦикла;
				
			Иначе
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(ТипОтбора);
				ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
				Для каждого ЗначениеМассива Из МассивЗначений Цикл
					СписокЗначенийОтбора.Добавить(ОписаниеТипа.ПривестиЗначение(ЗначениеМассива));
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Если ТекстыЗапроса.Количество() > 0 Тогда
		Запрос.Текст = СтрСоединить(ТекстыЗапроса, СИМВОЛЫ.ПС + "ОБЪЕДИНИТЬ ВСЕ" + СИМВОЛЫ.ПС);
		Запрос.УстановитьПараметр("МассивЗначений", МассивЗначений);
		РезультатЗапроса = Запрос.Выполнить();
		МассивЗначенийпоТипу = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку(ИмяРеквизита);
		Для каждого ЗначениеМассива Из МассивЗначенийпоТипу Цикл
			СписокЗначенийОтбора.Добавить(ЗначениеМассива);
		КонецЦикла;
		КонецЕсли;
		Возврат СписокЗначенийОтбора;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьЗначенияИзТабличногоДокумента(Команда)
	ТекущаяСтрока = Элементы.КомпоновщикНастроекНастройкиОтбор.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.КомпоновщикНастроекНастройкиОтбор.ТекущиеДанные;
		ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.ПолучитьОбъектПоИдентификатору(ТекущаяСтрока);
		ПравоеЗначение = ТекущиеДанные.ПравоеЗначение;
		Если ПравоеЗначение <> Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				МассивТипов = ПравоеЗначение.ТипЗначения.Типы();
			Иначе
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(ТипЗнч(ПравоеЗначение));
			КонецЕсли;
			ОписаниеТиповПравогоЗначения = Новый ОписаниеТипов(МассивТипов);
		Иначе
			ОписаниеТиповПравогоЗначения = КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ТекущиеДанные.ЛевоеЗначение).Тип;
		КонецЕсли;
		МассивЗначений = ЗначенияПоРеквизиту(ОписаниеТиповПравогоЗначения, Реквизиты, ОБъект.ТабличныйДокумент);
		Если МассивЗначений.Количество() > 0 Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ПравоеЗначение = МассивЗначений;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьОкна();
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПриИзменении(Элемент)
	Объект.ТабличныйДокумент.Область(1,1).Текст = Реквизиты;
КонецПроцедуры
