# Core Dump Analysis Lab - WSL2

Автоматизированная лабораторная работа для анализа core dump файлов в WSL2 Linux окружении.

## 🚀 Быстрый старт

### Одна команда запуска

```bash
cd ~/project && echo "1. ДИАГНОСТИКА" && pwd && cat /proc/sys/kernel/core_pattern && ulimit -c && ls -la *.py *.sh && echo "2. ТЕСТ" && rm -f core.* && ulimit -c unlimited && echo "core.%e.%p.%t" | sudo tee /proc/sys/kernel/core_pattern && python3 -c "import os; os.kill(os.getpid(), 11)" && echo "CORE:" && ls -lh core.* && echo "3. ПОЛНЫЙ ЗАПУСК" && pkill -f python && rm -f core.* && chmod +x *.sh && ./setup_core.sh && python3 vulnerable_runtime.py & sleep 2 && python3 fuzzer.py && ./analyze_core.sh python3 && echo "4. РЕЗУЛЬТАТЫ" && ls -lh core.* && cat core_dumps/crash_reports/SUMMARY.txt
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
