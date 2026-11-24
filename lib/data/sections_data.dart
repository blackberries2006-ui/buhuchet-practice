import 'package:flutter/material.dart';

class SectionInfo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SectionInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<SectionInfo> sectionsInfo = [
  SectionInfo(
    title: 'I. Долгосрочные активы',
    description: 'Активы, которые используются в бизнесе больше 12 месяцев. Это фундамент любого предприятия: здания, станки, патенты, а также долгосрочные инвестиции.',
    icon: Icons.apartment_rounded, // Здания (лучше подходит)
    color: Colors.blue,
  ),
  SectionInfo(
    title: 'II. Производственные запасы',
    description: 'То, из чего делают продукцию и то, что используется в процессе. Сырье, материалы, топливо, запчасти и НДС по приобретенным ценностям.',
    icon: Icons.warehouse_rounded, // Склад (соответствует запасам)
    color: Colors.orange,
  ),
  SectionInfo(
    title: 'III. Затраты на производство',
    description: 'Все расходы, связанные с производством товаров или оказанием услуг. Здесь собираются затраты, чтобы потом сформировать себестоимость.',
    icon: Icons.factory_rounded,
    color: Colors.redAccent,
  ),
  SectionInfo(
    title: 'IV. Готовая продукция и товары',
    description: 'Результат работы предприятия. То, что уже готово к продаже: продукция на складе, товары в магазинах, торговая наценка.',
    icon: Icons.shopping_bag_rounded,
    color: Colors.green,
  ),
  SectionInfo(
    title: 'V. Денежные средства',
    description: 'Кровь бизнеса. Наличные в кассе, безналичные на расчетных и валютных счетах, деньги в пути и краткосрочные вложения.',
    icon: Icons.payments_rounded, // Деньги (купюры)
    color: Colors.teal,
  ),
  SectionInfo(
    title: 'VI. Расчеты',
    description: 'Долги и обязательства. С кем мы рассчитываемся: с поставщиками, покупателями, налоговой, рабочими, банками по кредитам.',
    icon: Icons.handshake_rounded,
    color: Colors.purple,
  ),
  SectionInfo(
    title: 'VII. Собственный капитал',
    description: 'Чистые активы компании. То, что принадлежит владельцам: уставный капитал, резервные фонды, нераспределенная прибыль.',
    icon: Icons.account_balance_rounded,
    color: Colors.indigo,
  ),
  SectionInfo(
    title: 'VIII. Финансовые результаты',
    description: 'Итоги работы. Доходы, расходы, прибыли и убытки. Здесь видно, заработала компания деньги или ушла в минус.',
    icon: Icons.trending_up_rounded,
    color: Colors.deepOrange,
  ),
  SectionInfo(
    title: 'Забалансовые счета',
    description: 'Ценности, которые нам не принадлежат, но находятся у нас на хранении или в аренде. Они не влияют на баланс, но учитывать их нужно.',
    icon: Icons.content_paste_rounded,
    color: Colors.brown,
  ),
];
