import '../models/entry_model.dart';

final List<Entry> allEntries = [
  // I. Долгосрочные активы
  Entry(dt: '08', kt: '60', description: 'Приобретение основного средства у поставщика', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08'),
  Entry(dt: '01', kt: '08', description: 'Ввод основного средства в эксплуатацию', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08'),
  Entry(dt: '08-4', kt: '60', description: 'Приобретение НМА у поставщика', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 04, 08'),
  Entry(dt: '04', kt: '08-4', description: 'Ввод НМА в эксплуатацию', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 04, 08'),
  Entry(dt: '08', kt: '76', description: 'Приняты услуги посредника по покупке ОС', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 08, 76'),
  Entry(dt: '08', kt: '07', description: 'Оборудование передано в монтаж', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 07, 08'),
  Entry(dt: '20', kt: '02', description: 'Начисление амортизации основных средств', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 20'),
  Entry(dt: '91-4', kt: '01', description: 'Списание остаточной стоимости выбывшего ОС', category: 'I. Долгосрочные активы', recommendation: 'счета 01, 02, 91'),

  // II. Производственные запасы
  Entry(dt: '10', kt: '60', description: 'Поступление материалов от поставщика', category: 'II. Производственные запасы', recommendation: 'счета 10, 18, 60'),
  Entry(dt: '20', kt: '10', description: 'Списание материалов в основное производство', category: 'II. Производственные запасы', recommendation: 'счета 10, 20'),
  Entry(dt: '10', kt: '71', description: 'Оприходованы материалы, приобретенные подотчетником', category: 'II. Производственные запасы', recommendation: 'счета 10, 71'),
  Entry(dt: '94', kt: '10', description: 'Выявлена недостача материалов на складе', category: 'II. Производственные запасы', recommendation: 'счета 10, 94'),
  Entry(dt: '10', kt: '76-3', description: 'Признание претензии к поставщику за недостачу', category: 'II. Производственные запасы', recommendation: 'счета 10, 76'),
  Entry(dt: '10', kt: '60', description: 'Приобретение топлива по электронным картам', category: 'II. Производственные запасы', recommendation: 'счета 10, 60'),
  Entry(dt: '18', kt: '60', description: 'Отражен входной НДС по приобретенным материалам', category: 'II. Производственные запасы', recommendation: 'счета 10, 18, 60'),

  // III. Затраты на производство
  Entry(dt: '20', kt: '70', description: 'Начислена зарплата работникам основного производства', category: 'III. Затраты на производство', recommendation: 'счета 20, 26, 70'),
  Entry(dt: '20', kt: '69', description: 'Начислены страховые взносы в ФСЗН', category: 'III. Затраты на производство', recommendation: 'счета 20, 69'),
  Entry(dt: '20', kt: '76-2', description: 'Начислены взносы в Белгосстрах', category: 'III. Затраты на производство', recommendation: 'счета 20, 76'),
  Entry(dt: '43', kt: '20', description: 'Выпуск готовой продукции из производства', category: 'III. Затраты на производство', recommendation: 'счета 20, 43'),
  Entry(dt: '20', kt: '26', description: 'Списаны общехозяйственные расходы', category: 'III. Затраты на производство', recommendation: 'счета 20, 26'),
  Entry(dt: '20', kt: '96', description: 'Формирование резерва предстоящих платежей', category: 'III. Затраты на производство', recommendation: 'счета 20, 96'),

  // IV. Готовая продукция и товары
  Entry(dt: '62', kt: '90-1', description: 'Отражена выручка от реализации покупателю', category: 'IV. Готовая продукция и товары', recommendation: 'счета 43, 62, 90'),
  Entry(dt: '90-4', kt: '43', description: 'Списана себестоимость реализованной продукции', category: 'IV. Готовая продукция и товары', recommendation: 'счета 43, 90'),
  Entry(dt: '90-2', kt: '68-2', description: 'Начислен НДС с выручки от реализации', category: 'IV. Готовая продукция и товары', recommendation: 'счета 68, 90'),
  Entry(dt: '90-5', kt: '26', description: 'Списаны управленческие расходы на реализацию', category: 'IV. Готовая продукция и товары', recommendation: 'счета 26, 90'),
  Entry(dt: '51', kt: '62', description: 'Зачислен аванс от покупателя на расчетный счет', category: 'IV. Готовая продукция и товары', recommendation: 'счета 51, 62'),
  Entry(dt: '76-5', kt: '68-2', description: 'Начислен НДС с полученного аванса', category: 'IV. Готовая продукция и товары', recommendation: 'счета 68, 76'),

  // V. Денежные средства
  Entry(dt: '50', kt: '51', description: 'Снятие наличных с расчетного счета в кассу', category: 'V. Денежные средства', recommendation: 'счета 50, 51'),
  Entry(dt: '51', kt: '50', description: 'Внесение наличных из кассы на расчетный счет', category: 'V. Денежные средства', recommendation: 'счета 50, 51'),
  Entry(dt: '71', kt: '50', description: 'Выдача подотчетному лицу из кассы', category: 'V. Денежные средства', recommendation: 'счета 50, 71'),
  Entry(dt: '50', kt: '71', description: 'Возврат неиспользованного аванса в кассу', category: 'V. Денежные средства', recommendation: 'счета 50, 71'),
  Entry(dt: '60', kt: '51', description: 'Оплата поставщику с расчетного счета', category: 'V. Денежные средства', recommendation: 'счета 51, 60'),
  Entry(dt: '51', kt: '62', description: 'Поступление оплаты от покупателя на р/с', category: 'V. Денежные средства', recommendation: 'счета 51, 62'),
  Entry(dt: '91-4', kt: '51', description: 'Оплата банковских услуг за РКО', category: 'V. Денежные средства', recommendation: 'счета 51, 91'),

  // VI. Расчеты
  Entry(dt: '70', kt: '68-4', description: 'Удержан подоходный налог из заработной платы', category: 'VI. Расчеты', recommendation: 'счета 68, 70'),
  Entry(dt: '70', kt: '50', description: 'Выплата заработной платы из кассы', category: 'VI. Расчеты', recommendation: 'счета 50, 70'),
  Entry(dt: '70', kt: '51', description: 'Выплата заработной платы с р/с', category: 'VI. Расчеты', recommendation: 'счета 51, 70'),
  Entry(dt: '68-4', kt: '51', description: 'Перечислен подоходный налог в бюджет', category: 'VI. Расчеты', recommendation: 'счета 51, 68'),
  Entry(dt: '68-3', kt: '51', description: 'Уплата налога на прибыль в бюджет', category: 'VI. Расчеты', recommendation: 'счета 51, 68'),
  Entry(dt: '51', kt: '66', description: 'Получен краткосрочный кредит на р/с', category: 'VI. Расчеты', recommendation: 'счета 51, 66'),
  Entry(dt: '60', kt: '66-1', description: 'Переоформление долга поставщику в краткосрочный кредит', category: 'VI. Расчеты', recommendation: 'счета 60, 66'),

  // VII. Собственный капитал
  Entry(dt: '75-1', kt: '80', description: 'Формирование уставного капитала после регистрации', category: 'VII. Собственный капитал', recommendation: 'счета 75, 80'),
  Entry(dt: '75-2', kt: '68-4', description: 'Удержание подоходного налога с дивидендов', category: 'VII. Собственный капитал', recommendation: 'счета 68, 75'),
  Entry(dt: '84', kt: '82', description: 'Отчисления в резервный капитал из чистой прибыли', category: 'VII. Собственный капитал', recommendation: 'счета 82, 84'),
  Entry(dt: '86', kt: '98', description: 'Получение целевого финансирования', category: 'VII. Собственный капитал', recommendation: 'счета 86, 98'),

  // VIII. Финансовые результаты
  Entry(dt: '99', kt: '68-3', description: 'Начисление налога на прибыль', category: 'VIII. Финансовые результаты', recommendation: 'счета 68, 99'),
  Entry(dt: '99', kt: '84', description: 'Списание чистой прибыли на нераспределенную', category: 'VIII. Финансовые результаты', recommendation: 'счета 84, 99'),
  Entry(dt: '84', kt: '99', description: 'Списание убытка за счет нераспределенной прибыли', category: 'VIII. Финансовые результаты', recommendation: 'счета 84, 99'),
  Entry(dt: '99', kt: '91-1', description: 'Списание сальдо прочих доходов и расходов (прибыль)', category: 'VIII. Финансовые результаты', recommendation: 'счета 91, 99'),
  Entry(dt: '76-3', kt: '51', description: 'Уплата штрафа по претензии контрагента', category: 'VIII. Финансовые результаты', recommendation: 'счета 51, 76'),
  Entry(dt: '91-2', kt: '68-2', description: 'Начислен НДС от прочих доходов', category: 'VIII. Финансовые результаты', recommendation: 'счета 68, 91'),
];