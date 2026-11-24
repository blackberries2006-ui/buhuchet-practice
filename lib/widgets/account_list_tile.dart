import 'package:flutter/material.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';

class AccountListTile extends StatefulWidget {
  final Account account;

  const AccountListTile({super.key, required this.account});

  @override
  State<AccountListTile> createState() => _AccountListTileState();
}

class _AccountListTileState extends State<AccountListTile> {
  bool isExpanded = false;

  Color _getTypeColor(String type) {
    switch (type) {
      case 'А': return AppTheme.success;
      case 'П': return AppTheme.error;
      case 'АП': return AppTheme.warning;
      case 'З': return Colors.grey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = isDark ? AppTheme.darkSurface : Colors.white;
    Color textColor = isDark ? Colors.white : AppTheme.ink;
    
    bool hasSubs = widget.account.subAccounts.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Основная строка (кликабельная)
          InkWell(
            onTap: hasSubs ? () {
              setState(() { isExpanded = !isExpanded; });
            } : null,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.account.num,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.account.name,
                          style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.account.section,
                          style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTypeColor(widget.account.type).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.account.type,
                      style: TextStyle(color: _getTypeColor(widget.account.type), fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                  if (hasSubs) ...[
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.textGrey,
                    ),
                  ]
                ],
              ),
            ),
          ),
          
          // Выпадающий список субсчетов
          if (hasSubs && isExpanded)
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 12),
                  ...widget.account.subAccounts.map((sub) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${sub.num}  ',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary, fontSize: 15),
                          ),
                          Expanded(
                            child: Text(
                              sub.name,
                              style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
