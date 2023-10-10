import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../services/api_dataprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Employee>> _employeesFuture;

  @override
  void initState() {
    super.initState();
    _employeesFuture = EmployeeService.fetchEmployees();
    _tabController = TabController(length: 0, vsync: this);
  }

  void deleteEmployee(int index) {
    setState(() {
      _employeesFuture = _employeesFuture.then((employees) {
        employees.removeAt(index);
        return employees;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _employeesFuture = EmployeeService.fetchEmployees();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: FutureBuilder<List<Employee>>(
            future: _employeesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text('Error: Failed to load employees');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text('No Employees Data available.'),
                  ),
                );
              } else {
                final employees = snapshot.data;
                _tabController =
                    TabController(length: employees?.length ?? 0, vsync: this);
                return TabBar(
                  controller: _tabController,
                  tabs: [
                    for (var employee in employees!)
                      Tab(
                        text:
                            '${employee.firstName} ${employee.lastName}',
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error: Failed to load employees');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees available.'));
          } else {
            final employees = snapshot.data;
            return TabBarView(
              controller: _tabController,
              children: [
                for (var employee in employees!)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  deleteEmployee(employees
                                      .indexOf(employee));
                                },
                                child: const Text('Delete'),
                              ),
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(employee.avatar),
                                radius: 50,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'First Name: ${employee.firstName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Last Name: ${employee.lastName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Email: ${employee.email}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                const Center(child: Text('Employee Details')),
              ],
            );
          }
        },
      ),
    );
  }
}
