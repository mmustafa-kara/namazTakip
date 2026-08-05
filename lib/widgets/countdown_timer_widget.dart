import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

/// Bir sonraki namaz vaktine kalan süreyi gösteren dinamik sayaç.
/// OPTIMIZATIONS.md Kuralı: Timer saniyede bir tetiklendiğinde tüm UI'ı rebuild
/// etmemek için kendi StatefulWidget'ı içine hapsedilmiştir. Yalnızca metin güncellenir.
class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetTime;
  
  /// Geri sayım bittiğinde (00:00:00) tetiklenecek callback.
  /// (Örn: Vakit girdi, ViewModel'ı yenile)
  final VoidCallback? onTimerComplete;

  const CountdownTimerWidget({
    super.key,
    required this.targetTime,
    this.onTimerComplete,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    // Her saniye sadece bu widget'ın state'ini güncelleyen Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    final difference = widget.targetTime.difference(now);
    
    if (difference.isNegative) {
      _timer.cancel();
      if (_remaining != Duration.zero) {
        setState(() {
          _remaining = Duration.zero;
        });
        widget.onTimerComplete?.call();
      }
    } else {
      setState(() {
        _remaining = difference;
      });
    }
  }

  @override
  void didUpdateWidget(covariant CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Eğer hedef saat değişirse sayacı yeniden başlat
    if (oldWidget.targetTime != widget.targetTime) {
      _calculateRemaining();
      if (!_timer.isActive) {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _calculateRemaining();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    
    // Saat 0 ise "45:30" formatında göster (daha temiz)
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Sadece bu metin build edilecek, üstteki ana kartlar veya dashboard etkilenmeyecek.
    return Text(
      _formatDuration(_remaining),
      style: AppTypography.timerDisplay(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
