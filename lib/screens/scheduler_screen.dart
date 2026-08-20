import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
 
class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({Key? key}) : super(key: key);
 
  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}
 
class _SchedulerScreenState extends State<SchedulerScreen> {
  // [NEW] Kept as a separate untouched backup so the Refresh button can
  // restore the original seed data even after tasks are deleted.
  static final List<Map<String, dynamic>> _initialTasks = [
    {
      "name": "Weekly D: Drive Cleanup",
      "frequency": "Once",
      "nextRun": "2026-08-11T03:00:00.645",
      "items": "0 items",
      "method": "Zero Fill (1-pass)",
      "status": "Active",
    },
    {
      "name": "Nightly Temp File Erase",
      "frequency": "Once",
      "nextRun": "2026-08-09T22:30:00.645",
      "items": "0 items",
      "method": "Zero Fill (1-pass)",
      "status": "Active",
    },
    {
      "name": "Monthly Full Backup Wipe",
      "frequency": "Once",
      "nextRun": "2026-08-13T01:00:00.645",
      "items": "0 items",
      "method": "Zero Fill (1-pass)",
      "status": "Paused",
    },
    {
      "name": "Quarterly USB Scrub",
      "frequency": "Once",
      "nextRun": "2026-05-01T04:00:00.000",
      "items": "0 items",
      "method": "Zero Fill (1-pass)",
      "status": "Active",
    },
  ];
 
  late List<Map<String, dynamic>> tasks;
 
  @override
  void initState() {
    super.initState();
    tasks = _initialTasks.map((t) => Map<String, dynamic>.from(t)).toList();
  }
 
  // [NEW] Opens the "Delete Task" confirmation popup before actually
  // removing a task from the list.
  void _openDeleteConfirmDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      builder: (context) => _DeleteTaskDialog(
        onConfirm: () {
          setState(() {
            tasks.removeAt(index);
          });
        },
      ),
    );
  }
 
  void _openCreateTaskDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      builder: (context) => CreateScheduledTaskDialog(
        onSave: (newTask) {
          setState(() {
            tasks.add(newTask);
          });
        },
      ),
    );
  }
 
  void _openEditTaskDialog(int index) {
    final task = tasks[index];
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      builder: (context) => EditScheduledTaskDialog(
        taskData: task,
        onSave: (updatedData) {
          setState(() {
            tasks[index] = updatedData;
          });
        },
      ),
    );
  }
 
  void _openExecutionDialog(String taskName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (context) => _TaskExecutionDialog(taskName: taskName),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Scheduler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Automate erasure tasks on a recurring schedule',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Tooltip(
                      message: 'Refresh tasks',
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2937),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      textStyle: const TextStyle(color: Colors.white, fontSize: 11),
                      child: InkWell(
                        onTap: () {
                          // [NEW] Simulates re-fetching from the server —
                          // restores the original task list.
                          setState(() {
                            tasks = _initialTasks
                                .map((t) => Map<String, dynamic>.from(t))
                                .toList();
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _openCreateTaskDialog,
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text(
                        'New Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: tasks.isEmpty
                    ? _buildEmptyState()
                    : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Expanded(flex: 3, child: Text('Task Name', style: _headerStyle)),
                          Expanded(flex: 1, child: Text('Frequency', style: _headerStyle)),
                          Expanded(flex: 2, child: Text('Next Run', style: _headerStyle)),
                          Expanded(flex: 1, child: Text('Items', style: _headerStyle)),
                          Expanded(flex: 2, child: Text('Method', style: _headerStyle)),
                          Expanded(flex: 1, child: Text('Status', style: _headerStyle)),
                          SizedBox(width: 145, child: Text('Actions', style: _headerStyle)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: tasks.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Color(0xFFE5E7EB),
                        ),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final isActive = task["status"] == "Active";
 
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 16,
                                        color: Color(0xFF6B7280),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        task["name"],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF1F2937),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(task["frequency"], style: _rowTextStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Tooltip(
                                    message: task["nextRun"],
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F2937),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    textStyle: const TextStyle(color: Colors.white, fontSize: 11),
                                    child: Text(task["nextRun"], style: _rowTextStyle),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(task["items"], style: _rowTextStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(task["method"], style: _rowTextStyle),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(0xFFF0FDFA)
                                            : const Color(0xFFE5E7EB),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        task["status"],
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isActive
                                              ? const Color(0xFF0D9488)
                                              : const Color(0xFF4B5563),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 145,
                                  child: Row(
                                    children: [
                                      _HoverActionButton(
                                        icon: isActive
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        tooltip: isActive ? 'Pause Task' : 'Resume Task',
                                        baseIconColor: isActive
                                            ? const Color(0xFF4B5563)
                                            : const Color(0xFF0D9488),
                                        hoverBgColor: isActive
                                            ? const Color(0xFFFFFBEB)
                                            : const Color(0xFFCCFBF1),
                                        hoverIconColor: isActive
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF0D9488),
                                        onTap: () {
                                          setState(() {
                                            tasks[index]["status"] =
                                                isActive ? "Paused" : "Active";
                                          });
                                        },
                                      ),
                                      _HoverActionButton(
                                        icon: Icons.flash_on_rounded,
                                        tooltip: 'Run Task Now',
                                        baseIconColor: const Color(0xFF0D9488),
                                        hoverBgColor: const Color(0xFFCCFBF1),
                                        hoverIconColor: const Color(0xFF0D9488),
                                        onTap: () => _openExecutionDialog(task["name"]),
                                      ),
                                      _HoverActionButton(
                                        icon: Icons.edit_outlined,
                                        tooltip: 'Edit Task',
                                        baseIconColor: const Color(0xFF6B7280),
                                        hoverBgColor: const Color(0xFFF3F4F6),
                                        hoverIconColor: const Color(0xFF6B7280),
                                        onTap: () => _openEditTaskDialog(index),
                                      ),
                                      _HoverActionButton(
                                        icon: Icons.delete_outline_rounded,
                                        tooltip: 'Delete Task',
                                        baseIconColor: const Color(0xFFEF4444),
                                        hoverBgColor: const Color(0xFFE5E7EB),
                                        hoverIconColor: const Color(0xFFEF4444),
                                        // [CHANGED] Opens a confirmation
                                        // popup instead of deleting instantly.
                                        onTap: () => _openDeleteConfirmDialog(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  // [NEW] Shown when the tasks list is empty (after deleting all tasks).
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
            ),
            child: const Icon(
              Icons.access_time_rounded,
              size: 28,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No scheduled tasks yet',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _openCreateTaskDialog,
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: const Text(
              'Create First Task',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
 
  static const TextStyle _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4B5563),
  );
 
  static const TextStyle _rowTextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF374151),
  );
}
 
// ==========================================
// [NEW] DELETE TASK CONFIRMATION DIALOG
// ==========================================
 
class _DeleteTaskDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _DeleteTaskDialog({required this.onConfirm});
 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delete Task',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure you want to delete this task? This action cannot be undone.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _HoverCancelButton(
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
 
// ==========================================
// TASK EXECUTION DIALOG (Run Task Now popup)
// ==========================================
 
class _TaskExecutionDialog extends StatefulWidget {
  final String taskName;
  const _TaskExecutionDialog({required this.taskName});
 
  @override
  State<_TaskExecutionDialog> createState() => _TaskExecutionDialogState();
}
 
class _TaskExecutionDialogState extends State<_TaskExecutionDialog> {
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  int _stepIndex = -1;
  int _progress = 0;
  bool _stopped = false;
  bool _completed = false;
 
  final List<String> _stepLabels = const [
    'Initializing...',
    'Scanning target directories...',
    'Erasing: cache_v1.db',
    'Erasing: temp_img_29.png',
    'Erasing: error_log_2025.txt',
    'Erasing: session_data.tmp',
    'Erasing: hiberfil.sys (Mock)',
    'Erasing: pagefile.sys (Mock)',
    'Finalizing...',
    'Verifying erasure...',
    'Completed successfully.',
  ];
 
  final List<Map<String, String>> _items = const [
    {'name': 'cache_v1.db', 'path': 'C:\\Users\\AppData\\Local\\Temp'},
    {'name': 'temp_img_29.png', 'path': 'C:\\Users\\Downloads'},
    {'name': 'error_log_2025.txt', 'path': 'C:\\System\\Logs'},
    {'name': 'session_data.tmp', 'path': 'C:\\Users\\AppData\\Local'},
    {'name': 'hiberfil.sys (Mock)', 'path': 'C:\\'},
    {'name': 'pagefile.sys (Mock)', 'path': 'C:\\'},
  ];
 
  late List<String> _itemStatus;
 
  @override
  void initState() {
    super.initState();
    _itemStatus = List.filled(_items.length, 'pending');
    _startExecution();
  }
 
  void _startExecution() {
    _timer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
      if (_stopped || _completed) {
        timer.cancel();
        return;
      }
      setState(() {
        _stepIndex++;
        _progress = (((_stepIndex + 1) / _stepLabels.length) * 100).round();
        if (_progress > 100) _progress = 100;
        _applyItemStatusForStep(_stepIndex);
 
        if (_stepIndex >= _stepLabels.length - 1) {
          _progress = 100;
          _completed = true;
          for (int i = 0; i < _itemStatus.length; i++) {
            _itemStatus[i] = 'erased';
          }
          timer.cancel();
        }
      });
    });
  }
 
  void _applyItemStatusForStep(int step) {
    if (step == 2) {
      _itemStatus[0] = 'erasing';
    } else if (step == 3) {
      _itemStatus[0] = 'erased';
      _itemStatus[1] = 'erasing';
    } else if (step == 4) {
      _itemStatus[1] = 'erased';
      _itemStatus[2] = 'erasing';
    } else if (step == 5) {
      _itemStatus[2] = 'erased';
      _itemStatus[3] = 'erasing';
    } else if (step == 6) {
      _itemStatus[3] = 'erased';
      _itemStatus[4] = 'erasing';
    } else if (step == 7) {
      _itemStatus[4] = 'erased';
      _itemStatus[5] = 'erasing';
    } else if (step == 8) {
      _itemStatus[5] = 'erased';
    }
  }
 
  void _stopExecution() {
    _timer?.cancel();
    setState(() {
      _stopped = true;
      for (int i = 0; i < _itemStatus.length; i++) {
        if (_itemStatus[i] == 'erasing') {
          _itemStatus[i] = 'stopped';
        }
      }
    });
  }
 
  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
 
  String get _currentLabel {
    if (_stopped) return 'Execution stopped by user.';
    if (_stepIndex < 0) return _stepLabels[0];
    if (_stepIndex >= _stepLabels.length) return _stepLabels.last;
    return _stepLabels[_stepIndex];
  }
 
  @override
  Widget build(BuildContext context) {
    final bool showCloseButton = _stopped || _completed;
 
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0FDFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.show_chart_rounded,
                      color: Color(0xFF0D9488),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Executing: ${widget.taskName}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _currentLabel,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$_progress%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress / 100,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE0E7FF),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Processing Items',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final status = _itemStatus[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.insert_drive_file_outlined, size: 18, color: Color(0xFF6B7280)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name']!,
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937), fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          item['path']!,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildItemStatus(status),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!showCloseButton)
                    OutlinedButton.icon(
                      onPressed: _stopExecution,
                      icon: const Icon(Icons.stop_rounded, size: 16, color: Color(0xFFDC2626)),
                      label: const Text(
                        'Stop Execution',
                        style: TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEF2F2),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E7EB),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _buildItemStatus(String status) {
    switch (status) {
      case 'erasing':
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync_rounded, size: 13, color: Color(0xFF0D9488)),
            SizedBox(width: 4),
            Text('Erasing...', style: TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.w500)),
          ],
        );
      case 'erased':
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF0D9488)),
            SizedBox(width: 4),
            Text('Erased', style: TextStyle(fontSize: 12, color: Color(0xFF0D9488), fontWeight: FontWeight.w500)),
          ],
        );
      case 'stopped':
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel_rounded, size: 13, color: Color(0xFFDC2626)),
            SizedBox(width: 4),
            Text('Stopped', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626), fontWeight: FontWeight.w500)),
          ],
        );
      default:
        return const Text('Pending', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)));
    }
  }
}
 
// ==========================================
// HOVERABLE ACTION BUTTON
// ==========================================
 
class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final Color baseIconColor;
  final Color hoverBgColor;
  final Color hoverIconColor;
  final VoidCallback onTap;
 
  const _HoverActionButton({
    required this.icon,
    required this.tooltip,
    required this.baseIconColor,
    required this.hoverBgColor,
    required this.hoverIconColor,
    required this.onTap,
  });
 
  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}
 
class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 11),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _isHovered ? widget.hoverBgColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: _isHovered ? widget.hoverIconColor : widget.baseIconColor,
            ),
          ),
        ),
      ),
    );
  }
}
 
// ==========================================
// [NEW] HOVERABLE TASK NAME FIELD  (Point 2)
// Pale green hover background on the "Task Name"
// text box. Goes back to white on hover-exit,
// and stays white with teal border while focused.
// ==========================================
 
class _HoverTaskNameField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
 
  const _HoverTaskNameField({
    required this.controller,
    required this.hintText,
  });
 
  @override
  State<_HoverTaskNameField> createState() => _HoverTaskNameFieldState();
}
 
class _HoverTaskNameFieldState extends State<_HoverTaskNameField> {
  bool _isHovered = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
 
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }
 
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final bool showHoverFill = _isHovered && !_isFocused;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: showHoverFill ? const Color(0xFFF0FDFA) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: _isHovered ? const Color(0xFF0F766E) : const Color(0xFFD1D5DB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF0F766E)),
          ),
        ),
      ),
    );
  }
}
 
// ==========================================
// [NEW] HOVERABLE TARGET BUTTON  (Point 4 - top half)
// Used for "Add File" and "Add Folder". Pale green
// background + teal green border on hover.
// ==========================================
 
class _HoverTargetButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
 
  const _HoverTargetButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
 
  @override
  State<_HoverTargetButton> createState() => _HoverTargetButtonState();
}
 
class _HoverTargetButtonState extends State<_HoverTargetButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: OutlinedButton.icon(
        onPressed: widget.onTap,
        icon: Icon(widget.icon, size: 16, color: const Color(0xFF374151)),
        label: Text(
          widget.label,
          style: const TextStyle(color: Color(0xFF374151), fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: _isHovered ? const Color(0xFFF0FDFA) : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(
            color: _isHovered ? const Color(0xFF0F766E) : const Color(0xFFD1D5DB),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
 
// ==========================================
// [NEW] HOVERABLE CANCEL BUTTON  (Point 5)
// White by default, teal-green background on hover,
// white text on hover, back to normal on hover-exit.
// ==========================================
 
class _HoverCancelButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HoverCancelButton({required this.onTap});
 
  @override
  State<_HoverCancelButton> createState() => _HoverCancelButtonState();
}
 
class _HoverCancelButtonState extends State<_HoverCancelButton> {
  bool _isHovered = false;
 
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: TextButton.styleFrom(
          backgroundColor: _isHovered ? const Color(0xFF0F766E) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: _isHovered ? Colors.white : const Color(0xFF374151),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
 
// ==========================================
// CREATE SCHEDULED TASK DIALOG POPUP (UPDATED)
// ==========================================
 
class CreateScheduledTaskDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const CreateScheduledTaskDialog({Key? key, required this.onSave}) : super(key: key);
 
  @override
  State<CreateScheduledTaskDialog> createState() => _CreateScheduledTaskDialogState();
}
 
class _CreateScheduledTaskDialogState extends State<CreateScheduledTaskDialog> {
  final TextEditingController _taskNameController = TextEditingController();
  String selectedFrequency = 'Daily';
  String selectedDate = '2026-08-07';
  String selectedTime = '09:00 AM';
  bool isRootIntact = true;
  String selectedMethod = 'Zero Fill (1-pass)';
 
  final List<String> frequencies = ['Once', 'Daily', 'Weekly', 'Monthly', 'Every Boot'];
  final List<String> erasureMethods = [
    'Zero Fill (1-pass)',
    'One Fill (1-pass)',
    'Random Data (1-pass)',
    'NIST SP 800-88 Rev1 (3-pass)',
    'DoD 5220.22-M (E) Extended (7-pass)',
    'DoD 5220.22-M (STD) (3-pass)',
    'HMG IS5 Enhanced (3-pass)',
    'Gutmann Method (35-pass)',
    'PCI DSS 3.2.1 (3-pass)',
    'ISO/IEC 27040:2015 (3-pass)',
  ];
 
  // [NEW] "Create Scheduled Task" stays disabled until the Task Name is filled.
  bool get _isFormValid => _taskNameController.text.trim().isNotEmpty;
 
  @override
  void initState() {
    super.initState();
    _taskNameController.addListener(() => setState(() {}));
  }
 
  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }
 
  // [NEW - Point 4] Opens the OS "Add File" picker directly
  Future<void> _pickFiles() async {
    await FilePicker.platform.pickFiles(allowMultiple: true);
  }
 
  // [NEW - Point 4] Opens the OS "Add Folder" picker directly
  Future<void> _pickFolder() async {
    await FilePicker.platform.getDirectoryPath();
  }
 
  void _createTask() {
    String time24 = "09:00:00";
    try {
      bool isPm = selectedTime.contains('PM');
      List<String> parts = selectedTime.replaceAll(RegExp(r'[AP]M'), '').trim().split(':');
      int h = int.parse(parts[0]);
      int m = int.parse(parts[1]);
      if (isPm && h < 12) h += 12;
      if (!isPm && h == 12) h = 0;
      time24 = "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00.000";
    } catch (_) {}
 
    final newTask = {
      "name": _taskNameController.text.trim().isEmpty ? "Untitled Task" : _taskNameController.text.trim(),
      "frequency": selectedFrequency,
      "nextRun": "$selectedDate" "T" "$time24",
      "items": "0 items",
      "method": selectedMethod,
      "status": "Active",
    };
 
    widget.onSave(newTask);
    Navigator.of(context).pop();
  }
 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Scheduled Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Color(0xFF6B7280)),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Set up an automated erasure task',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 18),
              _buildFieldLabel('Task Name'),
              const SizedBox(height: 6),
              // [CHANGED - Point 2] Task Name field now uses the hoverable widget
              _HoverTaskNameField(
                controller: _taskNameController,
                hintText: 'e.g., Daily Temp Cleanup',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Frequency'),
                        const SizedBox(height: 6),
                        _CustomDropdown(
                          value: selectedFrequency,
                          items: frequencies,
                          onChanged: (val) => setState(() => selectedFrequency = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Date'),
                        const SizedBox(height: 6),
                        _DatePickerFieldWidget(
                          date: selectedDate,
                          onDateChanged: (val) => setState(() => selectedDate = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Time'),
                        const SizedBox(height: 6),
                        _TimePickerFieldWidget(
                          time: selectedTime,
                          onTimeChanged: (val) => setState(() => selectedTime = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Target Files & Folders'),
              const SizedBox(height: 6),
              Row(
                children: [
                  // [CHANGED - Point 4] Add File button -> hoverable + direct OS picker
                  Expanded(
                    child: _HoverTargetButton(
                      icon: Icons.insert_drive_file_outlined,
                      label: 'Add File',
                      onTap: _pickFiles,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // [CHANGED - Point 4] Add Folder button -> hoverable + direct OS picker
                  Expanded(
                    child: _HoverTargetButton(
                      icon: Icons.folder_open_outlined,
                      label: 'Add Folder',
                      onTap: _pickFolder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      value: isRootIntact,
                      activeColor: const Color(0xFF0F766E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) => setState(() => isRootIntact = val ?? true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Leave root folder intact and erase only contents',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Erasure Method'),
              const SizedBox(height: 6),
              _CustomDropdown(
                value: selectedMethod,
                items: erasureMethods,
                isScrollableList: true,
                onChanged: (val) => setState(() => selectedMethod = val),
              ),
              const SizedBox(height: 24),
              // [CHANGED] Cancel is now a rectangle, white/teal-hover button
              // (same as the Edit dialog). Create Scheduled Task stays
              // disabled (grey) until Task Name is filled in.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _HoverCancelButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isFormValid ? _createTask : null,
                    style: ElevatedButton.styleFrom(
                      // [CHANGED - Point 1] Disabled state now shows a light/pale
                      // teal-green (instead of neutral grey) so it reads as a
                      // dimmed version of the same teal-green button, and turns
                      // full teal-green once every required field is filled in.
                      backgroundColor: _isFormValid
                          ? const Color(0xFF0F766E)
                          : const Color(0xFF99D8CE),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      elevation: 0,
                      disabledBackgroundColor: const Color(0xFF99D8CE),
                    ),
                    child: Text(
                      'Create Scheduled Task',
                      style: TextStyle(
                        color: _isFormValid ? Colors.white : Colors.white.withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF4B5563),
      ),
    );
  }
}
 
// ==========================================
// EDIT SCHEDULED TASK DIALOG POPUP
// ==========================================
 
class EditScheduledTaskDialog extends StatefulWidget {
  final Map<String, dynamic> taskData;
  final Function(Map<String, dynamic>) onSave;
 
  const EditScheduledTaskDialog({
    Key? key,
    required this.taskData,
    required this.onSave,
  }) : super(key: key);
 
  @override
  State<EditScheduledTaskDialog> createState() => _EditScheduledTaskDialogState();
}
 
class _EditScheduledTaskDialogState extends State<EditScheduledTaskDialog> {
  late TextEditingController _taskNameController;
  late String selectedFrequency;
  late String selectedDate;
  late String selectedTime;
  bool isRootIntact = true;
  late String selectedMethod;
 
  final List<String> frequencies = ['Once', 'Daily', 'Weekly', 'Monthly', 'Every Boot'];
  final List<String> erasureMethods = [
    'Zero Fill (1-pass)',
    'One Fill (1-pass)',
    'Random Data (1-pass)',
    'NIST SP 800-88 Rev1 (3-pass)',
    'DoD 5220.22-M (E) Extended (7-pass)',
    'DoD 5220.22-M (STD) (3-pass)',
    'HMG IS5 Enhanced (3-pass)',
    'Gutmann Method (35-pass)',
    'PCI DSS 3.2.1 (3-pass)',
    'ISO/IEC 27040:2015 (3-pass)',
  ];
 
  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.taskData['name'] ?? '');
    selectedFrequency = widget.taskData['frequency'] ?? 'Once';
 
    String nextRunStr = widget.taskData['nextRun'] ?? '2026-08-11T03:00:00.000';
    try {
      if (nextRunStr.contains('T')) {
        List<String> parts = nextRunStr.split('T');
        selectedDate = parts[0];
        String timePart = parts[1].substring(0, 5);
        List<String> tParts = timePart.split(':');
        int hour = int.parse(tParts[0]);
        int min = int.parse(tParts[1]);
        String period = hour >= 12 ? 'PM' : 'AM';
        if (hour == 0) {
          hour = 12;
        } else if (hour > 12) {
          hour -= 12;
        }
        selectedTime = '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $period';
      } else {
        selectedDate = '2026-02-18';
        selectedTime = '02:00 AM';
      }
    } catch (_) {
      selectedDate = '2026-02-18';
      selectedTime = '02:00 AM';
    }
 
    selectedMethod = widget.taskData['method'] ?? 'Zero Fill (1-pass)';
  }
 
  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }
 
  // [NEW - Point 4] Opens the OS "Add File" picker directly
  Future<void> _pickFiles() async {
    await FilePicker.platform.pickFiles(allowMultiple: true);
  }
 
  // [NEW - Point 4] Opens the OS "Add Folder" picker directly
  Future<void> _pickFolder() async {
    await FilePicker.platform.getDirectoryPath();
  }
 
  void _saveChanges() {
    String time24 = "03:00:00";
    try {
      bool isPm = selectedTime.contains('PM');
      List<String> parts = selectedTime.replaceAll(RegExp(r'[AP]M'), '').trim().split(':');
      int h = int.parse(parts[0]);
      int m = int.parse(parts[1]);
      if (isPm && h < 12) h += 12;
      if (!isPm && h == 12) h = 0;
      time24 = "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00.000";
    } catch (_) {}
 
    final updated = {
      "name": _taskNameController.text.trim().isEmpty ? "Untitled Task" : _taskNameController.text.trim(),
      "frequency": selectedFrequency,
      "nextRun": "$selectedDate" "T" "$time24",
      "items": widget.taskData['items'] ?? "0 items",
      "method": selectedMethod,
      "status": widget.taskData['status'] ?? "Active",
    };
 
    widget.onSave(updated);
    Navigator.of(context).pop();
  }
 
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Scheduled Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.close, size: 18, color: Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Set up an automated erasure task.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 18),
              const Text(
                'Task Name',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
              ),
              const SizedBox(height: 6),
              // [CHANGED - Point 2] Task Name field now uses the hoverable widget
              _HoverTaskNameField(
                controller: _taskNameController,
                hintText: 'e.g. Daily Temp Cleanup',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Frequency', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        const SizedBox(height: 6),
                        _CustomDropdown(
                          value: selectedFrequency,
                          items: frequencies,
                          onChanged: (val) => setState(() => selectedFrequency = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        const SizedBox(height: 6),
                        _DatePickerFieldWidget(
                          date: selectedDate,
                          onDateChanged: (newDate) => setState(() => selectedDate = newDate),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Time', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        const SizedBox(height: 6),
                        _TimePickerFieldWidget(
                          time: selectedTime,
                          onTimeChanged: (newTime) => setState(() => selectedTime = newTime),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Target Files & Folders', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 8),
              Row(
                children: [
                  // [CHANGED - Point 4] Add File button -> hoverable + direct OS picker
                  Expanded(
                    child: _HoverTargetButton(
                      icon: Icons.insert_drive_file_outlined,
                      label: 'Add File',
                      onTap: _pickFiles,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // [CHANGED - Point 4] Add Folder button -> hoverable + direct OS picker
                  Expanded(
                    child: _HoverTargetButton(
                      icon: Icons.folder_open_outlined,
                      label: 'Add Folder',
                      onTap: _pickFolder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: isRootIntact,
                      activeColor: const Color(0xFF0F766E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) => setState(() => isRootIntact = val ?? true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Leave root folder intact and erase only contents',
                    style: TextStyle(fontSize: 12, color: Color(0xFF374151)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Erasure Method:', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              const SizedBox(height: 6),
              _CustomDropdown(
                value: selectedMethod,
                items: erasureMethods,
                isScrollableList: true,
                onChanged: (val) => setState(() => selectedMethod = val),
              ),
              const SizedBox(height: 24),
              // [CHANGED - Point 5] Cancel now sits right next to Save Changes
              // (right-aligned, no wasted space on the left), and is hoverable.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _HoverCancelButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F766E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ==========================================
// CUSTOM DROPDOWN WIDGET WITH TEAL HOVER
// ==========================================
 
class _CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isScrollableList;
 
  const _CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.isScrollableList = false,
  });
 
  @override
  State<_CustomDropdown> createState() => _CustomDropdownState();
}
 
class _CustomDropdownState extends State<_CustomDropdown> {
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int? _hoveredIndex;
  // [NEW - Point 3 & 4] Explicit controller so the list scrolls reliably
  // (previously multiple un-controlled Scrollables could conflict) and so
  // the Scrollbar's drag-to-scroll works correctly.
  final ScrollController _listScrollController = ScrollController();
 
  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }
 
  void _openDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
 
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(dismissible: true, color: Colors.transparent, onDismiss: _closeDropdown),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              child: Container(
                width: size.width,
                constraints: BoxConstraints(maxHeight: widget.isScrollableList ? 220 : 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                // [CHANGED - HOVER FIX] Wrapped the list in a StatefulBuilder.
                // An OverlayEntry's `builder` is NOT automatically rebuilt when
                // the widget that inserted it (_CustomDropdownState) calls
                // setState — so updating `_hoveredIndex` via the outer setState
                // never actually repainted the overlay, and the teal-green
                // hover color never showed up for Frequency OR Erasure Method,
                // in either the Create Task or Edit Task popup. Using
                // setOverlayState (from StatefulBuilder) instead rebuilds this
                // overlay subtree directly, so the hover color now applies
                // immediately and correctly everywhere this dropdown is used.
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return Scrollbar(
                      controller: _listScrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _listScrollController,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isSelected = item == widget.value;
                          final isHovered = _hoveredIndex == index;
 
                          // [CHANGED - full-width hover color] The teal hover
                          // background now fills the ENTIRE row edge-to-edge
                          // (right side included) via the outer Container,
                          // instead of stopping short at the reserved strip —
                          // that was making the highlight look "cut in half".
                          // The hover-TRIGGER area (MouseRegion) still only
                          // covers the main content region, not the scrollbar
                          // strip — so hovering exactly over the scrollbar
                          // itself still doesn't light up the row, but hovering
                          // anywhere on the actual content colors the full row.
                          return Container(
                            decoration: BoxDecoration(
                              color: isHovered ? const Color(0xFF0F766E) : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MouseRegion(
                                    onEnter: (_) => setOverlayState(() => _hoveredIndex = index),
                                    onExit: (_) => setOverlayState(() => _hoveredIndex = null),
                                    child: InkWell(
                                      onTap: () {
                                        widget.onChanged(item);
                                        _closeDropdown();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isHovered ? Colors.white : const Color(0xFF374151),
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(Icons.check, size: 14, color: isHovered ? Colors.white : const Color(0xFF0F766E)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 18),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }
 
  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
        _hoveredIndex = null;
      });
    }
  }
 
  @override
  void dispose() {
    _closeDropdown();
    _listScrollController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _isOpen ? const Color(0xFF0F766E) : const Color(0xFFD1D5DB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}
 
// ==========================================
// DATE PICKER FIELD & POPUP
// ==========================================
 
class _DatePickerFieldWidget extends StatefulWidget {
  final String date;
  final ValueChanged<String> onDateChanged;
 
  const _DatePickerFieldWidget({required this.date, required this.onDateChanged});
 
  @override
  State<_DatePickerFieldWidget> createState() => _DatePickerFieldWidgetState();
}
 
class _DatePickerFieldWidgetState extends State<_DatePickerFieldWidget> {
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
 
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
 
  @override
  void initState() {
    super.initState();
    try {
      List<String> parts = widget.date.split('-');
      selectedYear = int.parse(parts[0]);
      selectedMonth = int.parse(parts[1]);
      selectedDay = int.parse(parts[2]);
    } catch (_) {
      selectedYear = 2026;
      selectedMonth = 8;
      selectedDay = 18;
    }
  }
 
  void _toggleCalendar() {
    if (_isOpen) {
      _closeCalendar();
    } else {
      _openCalendar();
    }
  }
 
  void _openCalendar() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
 
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(dismissible: true, color: Colors.transparent, onDismiss: _closeCalendar),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Container(
                width: 260,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: _CalendarPopupContent(
                  year: selectedYear,
                  month: selectedMonth,
                  day: selectedDay,
                  onSelect: (y, m, d) {
                    setState(() {
                      selectedYear = y;
                      selectedMonth = m;
                      selectedDay = d;
                    });
                    String formatted = "$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}";
                    widget.onDateChanged(formatted);
                    _closeCalendar();
                  },
                  onClose: _closeCalendar,
                ),
              ),
            ),
          ),
        ],
      ),
    );
 
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }
 
  void _closeCalendar() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }
 
  @override
  void dispose() {
    _closeCalendar();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleCalendar,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _isOpen ? const Color(0xFF0F766E) : const Color(0xFFD1D5DB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.date, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
              const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _CalendarPopupContent extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final Function(int, int, int) onSelect;
  final VoidCallback onClose;
 
  const _CalendarPopupContent({
    required this.year,
    required this.month,
    required this.day,
    required this.onSelect,
    required this.onClose,
  });
 
  @override
  State<_CalendarPopupContent> createState() => _CalendarPopupContentState();
}
 
class _CalendarPopupContentState extends State<_CalendarPopupContent> {
  late int currentYear;
  late int currentMonth;
  late int currentDay;
  bool showMonthPicker = false;
  int? hoveredMonthIndex;
  int? hoveredDay;
 
  final List<String> monthsList = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
 
  @override
  void initState() {
    super.initState();
    currentYear = widget.year;
    currentMonth = widget.month;
    currentDay = widget.day;
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => setState(() => showMonthPicker = !showMonthPicker),
              child: Row(
                children: [
                  Text(
                    '${monthsList[currentMonth - 1]}, $currentYear',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF6B7280)),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => currentYear++),
                  child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.arrow_drop_up, size: 18, color: Color(0xFF6B7280))),
                ),
                InkWell(
                  onTap: () => setState(() => currentYear--),
                  child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF6B7280))),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
 
        if (showMonthPicker)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              bool isSelected = (index + 1) == currentMonth;
              bool isHovered = hoveredMonthIndex == index;
              return MouseRegion(
                onEnter: (_) => setState(() => hoveredMonthIndex = index),
                onExit: (_) => setState(() => hoveredMonthIndex = null),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      currentMonth = index + 1;
                      showMonthPicker = false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected || isHovered ? const Color(0xFF0F766E) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      monthsList[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected || isHovered ? Colors.white : const Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        else
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                    .map((d) => Text(d, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))))
                    .toList(),
              ),
              const SizedBox(height: 6),
              _buildDaysGrid(),
            ],
          ),
 
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                widget.onSelect(currentYear, currentMonth, 1);
              },
              child: const Text('Clear', style: TextStyle(fontSize: 12, color: Color(0xFF0F766E), fontWeight: FontWeight.w500)),
            ),
            InkWell(
              onTap: () {
                DateTime now = DateTime.now();
                widget.onSelect(now.year, now.month, now.day);
              },
              child: const Text('Today', style: TextStyle(fontSize: 12, color: Color(0xFF0F766E), fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
    );
  }
 
  Widget _buildDaysGrid() {
    int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    int firstDayOfWeek = DateTime(currentYear, currentMonth, 1).weekday % 7;
 
    List<Widget> dayWidgets = [];
    for (int i = 0; i < firstDayOfWeek; i++) {
      dayWidgets.add(const SizedBox());
    }
 
    for (int day = 1; day <= daysInMonth; day++) {
      bool isSelected = (day == currentDay && currentYear == widget.year && currentMonth == widget.month);
      bool isHovered = hoveredDay == day;
 
      dayWidgets.add(
        MouseRegion(
          onEnter: (_) => setState(() => hoveredDay = day),
          onExit: (_) => setState(() => hoveredDay = null),
          child: InkWell(
            onTap: () => widget.onSelect(currentYear, currentMonth, day),
            borderRadius: BorderRadius.circular(50),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F766E) : (isHovered ? const Color(0xFFE5E7EB) : Colors.transparent),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: dayWidgets,
    );
  }
}
 
// ==========================================
// TIME PICKER FIELD & POPUP
// ==========================================
 
class _TimePickerFieldWidget extends StatefulWidget {
  final String time;
  final ValueChanged<String> onTimeChanged;
 
  const _TimePickerFieldWidget({required this.time, required this.onTimeChanged});
 
  @override
  State<_TimePickerFieldWidget> createState() => _TimePickerFieldWidgetState();
}
 
class _TimePickerFieldWidgetState extends State<_TimePickerFieldWidget> {
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
 
  late String selectedHour;
  late String selectedMin;
  late String selectedPeriod;
 
  @override
  void initState() {
    super.initState();
    try {
      List<String> parts = widget.time.split(' ');
      String hm = parts[0];
      selectedPeriod = parts[1];
      List<String> hmParts = hm.split(':');
      selectedHour = hmParts[0];
      selectedMin = hmParts[1];
    } catch (_) {
      selectedHour = '09';
      selectedMin = '00';
      selectedPeriod = 'AM';
    }
  }
 
  void _toggleTimePicker() {
    if (_isOpen) {
      _closeTimePicker();
    } else {
      _openTimePicker();
    }
  }
 
  void _openTimePicker() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
 
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(dismissible: true, color: Colors.transparent, onDismiss: _closeTimePicker),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Container(
                width: 210,
                height: 180,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: _TimePickerPopupContent(
                  hour: selectedHour,
                  min: selectedMin,
                  period: selectedPeriod,
                  onSelect: (h, m, p) {
                    setState(() {
                      selectedHour = h;
                      selectedMin = m;
                      selectedPeriod = p;
                    });
                    widget.onTimeChanged("$h:$m $p");
                    _closeTimePicker();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
 
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }
 
  void _closeTimePicker() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }
 
  @override
  void dispose() {
    _closeTimePicker();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleTimePicker,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _isOpen ? const Color(0xFF0F766E) : const Color(0xFFD1D5DB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.time, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
              const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _TimePickerPopupContent extends StatefulWidget {
  final String hour;
  final String min;
  final String period;
  final Function(String, String, String) onSelect;
 
  const _TimePickerPopupContent({
    required this.hour,
    required this.min,
    required this.period,
    required this.onSelect,
  });
 
  @override
  State<_TimePickerPopupContent> createState() => _TimePickerPopupContentState();
}
 
class _TimePickerPopupContentState extends State<_TimePickerPopupContent> {
  late String h;
  late String m;
  late String p;
 
  final List<String> hours = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> minutes = List.generate(60, (index) => index.toString().padLeft(2, '0'));
  final List<String> periods = ['AM', 'PM'];
 
  int? hoveredHourIdx;
  int? hoveredMinIdx;
  int? hoveredPeriodIdx;
 
  // [NEW - Point 1] Separate scroll controllers for the Hour and Minute
  // columns. Previously both ListViews had no controller, which made them
  // fight over the same PrimaryScrollController and stopped scrolling from
  // working in either column. Each column now scrolls independently.
  final ScrollController _hourScrollController = ScrollController();
  final ScrollController _minScrollController = ScrollController();
 
  @override
  void initState() {
    super.initState();
    h = widget.hour;
    m = widget.min;
    p = widget.period;
  }
 
  @override
  void dispose() {
    _hourScrollController.dispose();
    _minScrollController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Text('Hour', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
              const SizedBox(height: 4),
              Expanded(
                child: Scrollbar(
                  controller: _hourScrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _hourScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: hours.length,
                    itemBuilder: (context, index) {
                      String item = hours[index];
                      bool isSelected = item == h;
                      bool isHovered = hoveredHourIdx == index;
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredHourIdx = index),
                        onExit: (_) => setState(() => hoveredHourIdx = null),
                        child: InkWell(
                          onTap: () {
                            setState(() => h = item);
                            widget.onSelect(h, m, p);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected || isHovered ? const Color(0xFF0F766E) : Colors.transparent,
                              border: const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.5)),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 12, color: isSelected || isHovered ? Colors.white : const Color(0xFF374151)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
        Expanded(
          child: Column(
            children: [
              const Text('Min', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
              const SizedBox(height: 4),
              Expanded(
                child: Scrollbar(
                  controller: _minScrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _minScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: minutes.length,
                    itemBuilder: (context, index) {
                      String item = minutes[index];
                      bool isSelected = item == m;
                      bool isHovered = hoveredMinIdx == index;
                      return MouseRegion(
                        onEnter: (_) => setState(() => hoveredMinIdx = index),
                        onExit: (_) => setState(() => hoveredMinIdx = null),
                        child: InkWell(
                          onTap: () {
                            setState(() => m = item);
                            widget.onSelect(h, m, p);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected || isHovered ? const Color(0xFF0F766E) : Colors.transparent,
                              border: const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.5)),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 12, color: isSelected || isHovered ? Colors.white : const Color(0xFF374151)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1, color: Color(0xFFE5E7EB)),
        Expanded(
          child: Column(
            children: [
              const Text('Period', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF9CA3AF))),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: periods.length,
                  itemBuilder: (context, index) {
                    String item = periods[index];
                    bool isSelected = item == p;
                    bool isHovered = hoveredPeriodIdx == index;
                    return MouseRegion(
                      onEnter: (_) => setState(() => hoveredPeriodIdx = index),
                      onExit: (_) => setState(() => hoveredPeriodIdx = null),
                      child: InkWell(
                        onTap: () {
                          setState(() => p = item);
                          widget.onSelect(h, m, p);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected || isHovered ? const Color(0xFF0F766E) : Colors.transparent,
                          ),
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 12, color: isSelected || isHovered ? Colors.white : const Color(0xFF374151)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
 