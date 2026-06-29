import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import '../providers/debt_provider.dart';
import '../../data/models/debt_model.dart';
import 'package:intl/intl.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  
  bool _isDebt = true; // true = Utang, false = Piutang
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveDebt() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      
      final newDebt = DebtModel.create(
        name: name,
        amount: amount,
        isDebt: _isDebt,
        dueDate: _selectedDate,
      );

      Provider.of<DebtProvider>(context, listen: false).addDebt(newDebt);
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
          "Tambah Catatan",
          style: GoogleFonts.inter(
            color: settings.isDarkMode ? Colors.white : AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle Type
              Container(
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.white10 : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isDebt = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isDebt ? Colors.red[400] : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Saya Berutang",
                              style: GoogleFonts.inter(
                                color: _isDebt ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isDebt = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isDebt ? Colors.green[500] : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Piutang (Memberi Pinjaman)",
                              style: GoogleFonts.inter(
                                color: !_isDebt ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              Text("Nama Orang/Pihak", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Contoh: Budi, Bank, dll",
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.white10 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              
              Text("Nominal (Rp)", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [IndonesianThousandsFormatter()],
                decoration: InputDecoration(
                  hintText: "0",
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.white10 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Nominal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),

              Text("Tanggal Jatuh Tempo (Opsional)", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: settings.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      const SizedBox(width: 15),
                      Text(
                        _selectedDate == null 
                            ? "Pilih Tanggal" 
                            : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                        style: GoogleFonts.inter(
                          color: _selectedDate == null ? Colors.grey : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveDebt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "Simpan Catatan",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IndonesianThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove all non-digits
    String clean = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }
    
    final value = int.parse(clean);
    final formatter = NumberFormat.decimalPattern('id');
    final newText = formatter.format(value);
    
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
