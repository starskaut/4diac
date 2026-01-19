# Core Dump Analysis Lab - WSL2

Автоматизированная лабораторная работа для анализа core dump файлов в WSL2 Linux окружении.

## 🚀 Быстрый старт

### Одна команда запуска

```bash
cd ~/project && ulimit -c unlimited && echo "core.%e.%p.%t" | sudo tee /proc/sys/kernel/core_pattern && chmod +x *.sh && ./setup_core.sh && python3 vulnerable_runtime.py & sleep 2 && python3 fuzzer.py && ./analyze_core.sh python3
```

## 📁 Структура проекта

```
~/project/
├── vulnerable_runtime.py      # Сервер с уязвимостью (buffer overflow)
├── fuzzer.py                  # Фаззер для поиска ошибок
├── setup_core.sh              # Настройка системы (kernel, ulimit)
├── analyze_core.sh            # Анализ core dump через GDB
├── core_dumps/                # Папка с core файлами
│   └── crash_reports/         # GDB отчёты и анализ
└── README.md                  # Этот файл
```

## 💾 Установка

### Предварительно
- WSL2 Ubuntu 22.04
- Python 3
- GDB

### Проверка зависимостей

```bash
python3 --version
gdb --version
```

### Если что-то отсутствует

```bash
sudo apt update
sudo apt install python3 python3-pip gdb
```

## ▶️ Запуск

### Полный запуск (все тесты)

```bash
cd ~/project
ulimit -c unlimited
chmod +x *.sh
./setup_core.sh
python3 vulnerable_runtime.py &
sleep 2
python3 fuzzer.py
./analyze_core.sh python3
```

## 📚 Лабораторная работа

### Ожидаемый результат

✅ 5MB+ core dump файл  
✅ 2+ GDB отчёта с backtrace  
✅ Buffer overflow найден  
✅ SUMMARY.txt готов к сдаче  


---

