import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive_centered_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/savings_goal.dart';
import '../cubit/savings_goal_cubit.dart';

class AddEditGoalScreen extends StatefulWidget {
  final SavingsGoal? initialGoal;

  const AddEditGoalScreen({super.key, this.initialGoal});

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _currentAmountController;
  late final TextEditingController _notesController;

  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    final g = widget.initialGoal;
    _titleController = TextEditingController(text: g?.title ?? '');
    _targetAmountController = TextEditingController(
      text: g != null ? g.targetAmount.toString() : '',
    );
    _currentAmountController = TextEditingController(
      text: g != null ? g.currentAmount.toString() : '0',
    );
    _notesController = TextEditingController(text: g?.notes ?? '');

    _deadline = g?.deadline ?? DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _showDeleteDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Savings Goal'),
        content: const Text(
          'Are you sure you want to delete this savings goal? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.read<SavingsGoalCubit>().deleteGoal(
                widget.initialGoal!.id,
              );
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text(
              l10n.deleteButton,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.initialGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editGoalTitle : l10n.addGoalTitle),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteDialog(context, l10n),
            ),
        ],
      ),
      body: ResponsiveCenteredView(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.goalTitleLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.goalTitleRequiredError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _targetAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.targetAmountLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.amountRequiredError;
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return l10n.amountPositiveError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _currentAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.currentAmountLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0.h),
                InkWell(
                  onTap: _pickDeadline,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.deadlineLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat.yMMMd().format(_deadline)),
                  ),
                ),
                SizedBox(height: 16.0.h),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.noteLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 32.0.h),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final target = double.parse(
                        _targetAmountController.text.trim(),
                      );
                      final current =
                          double.tryParse(
                            _currentAmountController.text.trim(),
                          ) ??
                          0.0;
                      final now = DateTime.now();

                      final goal = SavingsGoal(
                        id:
                            widget.initialGoal?.id ??
                            now.millisecondsSinceEpoch.toString(),
                        title: _titleController.text.trim(),
                        targetAmount: target,
                        currentAmount: current,
                        deadline: _deadline,
                        notes: _notesController.text.trim(),
                        createdAt: widget.initialGoal?.createdAt ?? now,
                        updatedAt: now,
                        isCompleted: current >= target,
                      );

                      if (isEditing) {
                        context.read<SavingsGoalCubit>().updateGoal(goal);
                      } else {
                        context.read<SavingsGoalCubit>().addGoal(goal);
                      }

                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  ),
                  child: Text(l10n.saveButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
