import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import '../providers/faraid_provider.dart';
import '../../data/models/faraid_models.dart';
import '../../../debt_tracker/presentation/providers/debt_provider.dart';

class FaraidWizardScreen extends StatefulWidget {
  const FaraidWizardScreen({super.key});

  @override
  State<FaraidWizardScreen> createState() => _FaraidWizardScreenState();
}

class _FaraidWizardScreenState extends State<FaraidWizardScreen> {
  int _currentStep = 0;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Form Controllers for Asset
  final _assetNameController = TextEditingController();
  final _assetValueController = TextEditingController();

  @override
  void dispose() {
    _assetNameController.dispose();
    _assetValueController.dispose();
    super.dispose();
  }

  void _addAsset(FaraidProvider provider) {
    if (_assetNameController.text.isNotEmpty && _assetValueController.text.isNotEmpty) {
      double value = double.parse(_assetValueController.text.replaceAll(RegExp(r'[^0-9]'), ''));
      provider.addAsset(AssetModel(name: _assetNameController.text, value: value));
      _assetNameController.clear();
      _assetValueController.clear();
    }
  }

  void _useActiveDebt(FaraidProvider faraidProvider, DebtProvider debtProvider) {
    if (debtProvider.totalDebt > 0) {
      faraidProvider.addAsset(AssetModel(
        name: "Pelunasan Utang Aktif", 
        value: -debtProvider.totalDebt, 
        category: "Utang"
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada utang aktif yang tercatat.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    final faraidProvider = Provider.of<FaraidProvider>(context);
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: settings.isDarkMode ? Colors.white : AppTheme.textDark),
        title: Text(
          "Kalkulator Waris",
          style: GoogleFonts.inter(
            color: settings.isDarkMode ? Colors.white : AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.horizontal,
        elevation: 0,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (faraidProvider.totalAssets <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Total harta harus lebih dari 0.")),
              );
              return;
            }
            setState(() => _currentStep += 1);
          } else if (_currentStep == 1) {
            faraidProvider.calculateFaraid();
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep -= 1);
        },
        controlsBuilder: (context, details) {
          if (_currentStep == 2) return const SizedBox.shrink(); // Hide controls on result
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(_currentStep == 1 ? "Hitung Waris" : "Lanjut", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Kembali", style: GoogleFonts.inter(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text("Harta"),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _buildAssetStep(faraidProvider, debtProvider, settings, theme),
          ),
          Step(
            title: const Text("Keluarga"),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _buildHeirStep(faraidProvider, settings, theme),
          ),
          Step(
            title: const Text("Hasil"),
            isActive: _currentStep >= 2,
            content: _buildResultStep(faraidProvider, settings, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetStep(FaraidProvider provider, DebtProvider debtProvider, SettingsProvider settings, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Total Harta Peninggalan", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        Text(
          _currencyFormat.format(provider.totalAssets),
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24, color: theme.primaryColor),
        ),
        const SizedBox(height: 20),
        
        // Input Form
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _assetNameController,
                decoration: InputDecoration(
                  hintText: "Nama (Misal: Tabungan)",
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.white10 : Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _assetValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Nominal (Rp)",
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.white10 : Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => _addAsset(provider),
              icon: CircleAvatar(
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        
        // Import Debt Button
        InkWell(
          onTap: () => _useActiveDebt(provider, debtProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Text("Kurangi dengan Utang Aktif", style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        // Asset List
        if (provider.assets.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.assets.length,
            itemBuilder: (context, index) {
              final asset = provider.assets[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(asset.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                subtitle: Text(_currencyFormat.format(asset.value), style: GoogleFonts.inter(color: asset.value < 0 ? Colors.red : Colors.green)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => provider.removeAsset(index),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildHeirStep(FaraidProvider provider, SettingsProvider settings, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ahli Waris Utama", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        Text("Tandai siapa saja anggota keluarga inti yang masih hidup.", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 20),
        
        _buildCheckbox("Suami (Almarhumah adalah istri)", provider.heirs.isHusbandAlive, (val) {
          provider.heirs.isHusbandAlive = val!;
          if (val) provider.heirs.isWifeAlive = false; // Cannot have both husband and wife as heir for same person
          provider.updateHeirs(provider.heirs);
        }),
        _buildCheckbox("Istri (Almarhum adalah suami)", provider.heirs.isWifeAlive, (val) {
          provider.heirs.isWifeAlive = val!;
          if (val) {
            provider.heirs.isHusbandAlive = false;
            if (provider.heirs.wifeCount == 0) provider.heirs.wifeCount = 1;
          } else {
            provider.heirs.wifeCount = 0;
          }
          provider.updateHeirs(provider.heirs);
        }),
        
        if (provider.heirs.isWifeAlive)
          _buildCounter("Jumlah Istri", provider.heirs.wifeCount, (val) {
            provider.heirs.wifeCount = val;
            provider.updateHeirs(provider.heirs);
          }, min: 1, max: 4),

        const Divider(height: 30),
        
        _buildCheckbox("Ayah", provider.heirs.isFatherAlive, (val) {
          provider.heirs.isFatherAlive = val!;
          provider.updateHeirs(provider.heirs);
        }),
        _buildCheckbox("Ibu", provider.heirs.isMotherAlive, (val) {
          provider.heirs.isMotherAlive = val!;
          provider.updateHeirs(provider.heirs);
        }),

        const Divider(height: 30),
        
        _buildCounter("Anak Laki-laki", provider.heirs.sonCount, (val) {
          provider.heirs.sonCount = val;
          provider.updateHeirs(provider.heirs);
        }),
        _buildCounter("Anak Perempuan", provider.heirs.daughterCount, (val) {
          provider.heirs.daughterCount = val;
          provider.updateHeirs(provider.heirs);
        }),

        const Divider(height: 30),
        
        Text("Saudara (Logika Hijab)", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        if (provider.heirs.sonCount > 0 || provider.heirs.isFatherAlive)
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text("Mahjub (Terhalang): Saudara kandung tidak mendapat warisan karena ada Anak Laki-laki atau Ayah.", 
              style: GoogleFonts.inter(color: Colors.red[700], fontSize: 12)
            ),
          ),
        Opacity(
          opacity: (provider.heirs.sonCount > 0 || provider.heirs.isFatherAlive) ? 0.4 : 1.0,
          child: _buildCounter("Jumlah Saudara Kandung", provider.heirs.siblingCount, (val) {
            if (provider.heirs.sonCount > 0 || provider.heirs.isFatherAlive) return; // Locked
            provider.heirs.siblingCount = val;
            provider.updateHeirs(provider.heirs);
          }),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: GoogleFonts.inter(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _buildCounter(String title, int value, Function(int) onChanged, {int min = 0, int max = 20}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Text(value.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultStep(FaraidProvider provider, SettingsProvider settings, ThemeData theme) {
    if (provider.results.isEmpty) {
      return Center(child: Text("Tidak ada ahli waris yang berhak atau harta habis.", style: GoogleFonts.inter()));
    }

    // Prepare data for Pie Chart
    final List<Color> colors = [Colors.teal, Colors.blue, Colors.orange, Colors.purple, Colors.red, Colors.green, Colors.brown];
    final sections = List.generate(provider.results.length, (i) {
      final share = provider.results[i];
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: share.portion * 100,
        title: '${(share.portion * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });

    double totalKotor = provider.assets.where((a) => a.value > 0).fold(0.0, (sum, a) => sum + a.value);
    double totalUtang = provider.assets.where((a) => a.value < 0).fold(0.0, (sum, a) => sum + a.value).abs();

    return Column(
      children: [
        // Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ringkasan Harta", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Harta Kotor:", style: GoogleFonts.inter(color: Colors.grey)),
                Text(_currencyFormat.format(totalKotor), style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Dikurangi Utang:", style: GoogleFonts.inter(color: Colors.red)),
                Text("- ${_currencyFormat.format(totalUtang)}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.red)),
              ]),
              const Divider(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Harta Bersih (Dibagi):", style: GoogleFonts.inter(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                Text(_currencyFormat.format(provider.totalAssets), style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: theme.primaryColor, fontSize: 16)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 30),
        
        Text("Porsi Pembagian", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 20),

        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ...List.generate(provider.results.length, (i) {
          final share = provider.results[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              border: Border(left: BorderSide(color: colors[i % colors.length], width: 5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(share.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(share.relation, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text(
                  _currencyFormat.format(share.amount),
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              provider.resetAll();
              setState(() => _currentStep = 0);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Hitung Ulang", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}
