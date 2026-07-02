import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import '../providers/debt_provider.dart';
import 'add_debt_screen.dart';
import '../../data/models/debt_model.dart';

class DebtDashboardScreen extends StatefulWidget {
  const DebtDashboardScreen({super.key});

  @override
  State<DebtDashboardScreen> createState() => _DebtDashboardScreenState();
}

class _DebtDashboardScreenState extends State<DebtDashboardScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: settings.isDarkMode ? Colors.white : AppTheme.textDark),
        title: Text(
          "Catatan Utang Piutang",
          style: GoogleFonts.inter(
            color: settings.isDarkMode ? Colors.white : AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DebtProvider>(
        builder: (context, debtProvider, child) {
          if (debtProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final unpaidDebts = debtProvider.debts.where((d) => !d.isPaid).toList();
          final paidDebts = debtProvider.debts.where((d) => d.isPaid).toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(debtProvider, settings, theme),
                const SizedBox(height: 30),
                if (unpaidDebts.isNotEmpty) ...[
                  Text(
                    "Belum Lunas",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 15),
                  ...unpaidDebts.map((debt) => _buildDebtItem(debt, debtProvider, settings, theme)),
                  const SizedBox(height: 20),
                ],
                if (paidDebts.isNotEmpty) ...[
                  Text(
                    "Sudah Lunas",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  ...paidDebts.map((debt) => _buildDebtItem(debt, debtProvider, settings, theme, isPast: true)),
                ],
                if (unpaidDebts.isEmpty && paidDebts.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
                          const SizedBox(height: 15),
                          Text(
                            "Belum ada catatan utang/piutang.",
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0F4D3A),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDebtScreen()));
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Tambah", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSummaryCards(DebtProvider provider, SettingsProvider settings, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECEA), // Soft Red
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward, color: Colors.red[700], size: 16),
                      const SizedBox(width: 5),
                      Text("Total Utang Saya", style: GoogleFonts.inter(fontSize: 12, color: Colors.red[800], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _currencyFormat.format(provider.totalDebt),
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[900]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Soft Green
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.green[700], size: 16),
                      const SizedBox(width: 5),
                      Text("Total Piutang", style: GoogleFonts.inter(fontSize: 12, color: Colors.green[800], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _currencyFormat.format(provider.totalReceivable),
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebtItem(DebtModel debt, DebtProvider provider, SettingsProvider settings, ThemeData theme, {bool isPast = false}) {
    Color iconColor = debt.isDebt ? Colors.red : Colors.green;
    IconData iconData = debt.isDebt ? Icons.money_off : Icons.attach_money;
    
    if (isPast) {
      iconColor = Colors.grey;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dueDateOnly = debt.dueDate != null 
        ? DateTime(debt.dueDate!.year, debt.dueDate!.month, debt.dueDate!.day)
        : null;
    
    final isOverdue = !isPast && !debt.isPaid && 
        dueDateOnly != null && 
        dueDateOnly.isBefore(todayDate);
        
    final isDueToday = !isPast && !debt.isPaid && 
        dueDateOnly != null && 
        dueDateOnly.isAtSameMomentAs(todayDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPast ? Colors.grey.withOpacity(0.1) : iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      debt.name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15, 
                        color: isPast ? Colors.grey : theme.colorScheme.onSurface,
                        decoration: isPast ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      debt.isDebt ? "Saya berutang" : "Dia berutang",
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                    if (debt.dueDate != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month, 
                            size: 13, 
                            color: isPast 
                                ? Colors.grey 
                                : (isOverdue 
                                    ? (settings.isDarkMode ? Colors.red[300] : Colors.red[700])
                                    : (isDueToday ? (settings.isDarkMode ? Colors.orange[300] : Colors.orange[800]) : Colors.grey[600])),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Tempo: ${DateFormat('dd MMM yyyy', 'id_ID').format(debt.dueDate!)}",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: (isOverdue || isDueToday) ? FontWeight.w600 : FontWeight.normal,
                                color: isPast 
                                    ? Colors.grey 
                                    : (isOverdue 
                                        ? (settings.isDarkMode ? Colors.red[300] : Colors.red[700])
                                        : (isDueToday ? (settings.isDarkMode ? Colors.orange[300] : Colors.orange[800]) : Colors.grey[600])),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (isOverdue) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: settings.isDarkMode ? Colors.red[900]!.withOpacity(0.3) : Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: settings.isDarkMode ? Colors.red[800]!.withOpacity(0.5) : Colors.red[200]!, 
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            "Lewat Tempo",
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: settings.isDarkMode ? Colors.red[200] : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                      if (isDueToday) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: settings.isDarkMode ? Colors.orange[900]!.withOpacity(0.3) : Colors.orange[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: settings.isDarkMode ? Colors.orange[800]!.withOpacity(0.5) : Colors.orange[200]!, 
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            "Hari Ini",
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: settings.isDarkMode ? Colors.orange[200] : Colors.orange[900],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _currencyFormat.format(debt.amount),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, 
                  fontSize: 15,
                  color: isPast ? Colors.grey : (debt.isDebt ? Colors.red[700] : Colors.green[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => provider.togglePaidStatus(debt),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPast ? Colors.grey.withOpacity(0.2) : theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPast ? "Batalkan" : "Tandai Lunas",
                    style: GoogleFonts.inter(
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      color: isPast ? Colors.grey[700] : theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      title: Text(
                        "Hapus Catatan",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                      ),
                      content: Text(
                        "Apakah Anda yakin ingin menghapus catatan '${debt.name}' ini?",
                        style: GoogleFonts.inter(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text("Batal", style: GoogleFonts.inter(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.deleteDebt(debt);
                            Navigator.pop(ctx);
                          },
                          child: Text("Hapus", style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    size: 14,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
