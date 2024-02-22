import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:AquaPlan/database_helper.dart';
import 'package:AquaPlan/models/plan.dart';

class TakvimScreen extends StatefulWidget {
  final String defaultCity;
  final Plan? plan;
  const TakvimScreen({Key? key, required this.defaultCity, this.plan})
      : super(key: key);

  @override
  _TakvimScreenState createState() => _TakvimScreenState();
}

class _TakvimScreenState extends State<TakvimScreen> {
  DateTime? _selectedDate;
  TextEditingController _planController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    if (widget.plan != null) {
      _planController.text = widget.plan!.planName;
      _locationController.text = widget.plan!.location;
      _areaController.text = widget.plan!.area;
      _selectedDate = DateTime.parse(widget.plan!.selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan != null ? 'Plan Düzenle' : 'Plan Oluştur'),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Bilgisi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _planController,
              decoration: InputDecoration(
                hintText: 'Plan adını girin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Takvim:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Text('Tarih Seç'),
            ),
            SizedBox(height: 20),
            if (_selectedDate != null)
              Column(
                children: [
                  Text(
                    'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            SizedBox(height: 10),
            Text(
              'Konumu Girin:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Konumu girin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sulama Bilgisi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Sulama Bilgisi Girin',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pop(context);
              },
              child: Text(widget.plan != null ? 'Güncelle' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        return true;
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveData() async {
    if (widget.plan != null) {
      widget.plan!.planName = _planController.text;
      widget.plan!.location = _locationController.text;
      widget.plan!.area = _areaController.text;
      widget.plan!.selectedDate = _selectedDate!.toString();
      await _databaseHelper.updatePlan(widget.plan!);
    } else {
      Plan newPlan = Plan(
        planName: _planController.text,
        location: _locationController.text,
        area: _areaController.text,
        selectedDate: _selectedDate!.toString(),
      );
      await _databaseHelper.insertPlan(newPlan);
    }
  }
}
