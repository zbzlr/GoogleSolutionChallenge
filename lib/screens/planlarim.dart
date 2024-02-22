import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:AquaPlan/database_helper.dart';
import 'package:AquaPlan/models/plan.dart';
import 'takvim.dart';

class PlanlarimScreen extends StatefulWidget {
  final String defaultCity;
  const PlanlarimScreen({Key? key, required this.defaultCity})
      : super(key: key);

  @override
  _PlanlarimScreenState createState() => _PlanlarimScreenState();
}

class _PlanlarimScreenState extends State<PlanlarimScreen> {
  late DatabaseHelper _databaseHelper;
  late List<Plan> _plans;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _plans = [];
    _updatePlanList();
  }

  Future<void> _updatePlanList() async {
    _plans = await _databaseHelper.getAllPlans();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sulama Planları'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade900
            ], // Turuncu gradyan arka plan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakvimScreen(
                              defaultCity: widget.defaultCity,
                              plan: _plans[index],
                            ),
                          ),
                        ).then((value) {
                          _updatePlanList();
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _plans[index].planName,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Konum: ${_plans[index].location}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Açık mavi buton rengi
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TakvimScreen(defaultCity: widget.defaultCity),
                  ),
                ).then((value) {
                  _updatePlanList();
                });
              },
              child: Lottie.asset(
                'assets/plus.json',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
