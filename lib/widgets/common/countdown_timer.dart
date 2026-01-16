import 'dart:async';
import 'package:flutter/material.dart';
import 'package:campus_one/core/theme/app_theme.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  final TextStyle? style;

  const CountdownTimer({super.key, required this.targetDate, this.style});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculateTimeLeft());
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (widget.targetDate.isBefore(now)) {
      setState(() => _timeLeft = Duration.zero);
    } else {
      setState(() => _timeLeft = widget.targetDate.difference(now));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero) {
      return Text('NOW', style: widget.style ?? const TextStyle(fontWeight: FontWeight.w900, color: Colors.red));
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    if (days > 0) {
      return Text(
        'IN $days DAYS', 
        style: widget.style
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimeBlock(value: hours, label: 'H'),
        const Text(':', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
        _TimeBlock(value: minutes, label: 'M'),
        const Text(':', style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
        _TimeBlock(value: seconds, label: 'S'),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final int value;
  final String label;

  const _TimeBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        value.toString().padLeft(2, '0'),
        style: const TextStyle(fontWeight: FontWeight.w900, fontFamily: 'monospace', color: AppTheme.textPrimary),
      ),
    );
  }
}
