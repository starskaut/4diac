# Core Dump Analysis Lab - WSL2

Автоматизированная лабораторная работа для анализа core dump файлов в WSL2 Linux окружении.

## 📋 Содержание

- [Быстрый старт](#быстрый-старт)
- [Структура проекта](#структура-проекта)
- [Компоненты](#компоненты)
- [Установка](#установка)
- [Запуск](#запуск)
- [Результаты](#результаты)
- [Решение проблем](#решение-проблем)

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

## 🔧 Компоненты

### 1. vulnerable_runtime.py
- Mock-сервер на Python
- Слушает подключения на порту 61499
- Содержит уязвимость buffer overflow в функции `vulnerable_parse()`
- Обрабатывает фаззированные данные

### 2. fuzzer.py
- Отправляет 6 тестов с возрастающим размером данных
- Test 1-3: Buffer overflow (128-256 байт)
- Test 4-6: Максимальные payload (1024 байта)
- Генерирует core dump при краше сервера

### 3. setup_core.sh
- Включает `ulimit -c unlimited` для core dump
- Настраивает `kernel.core_pattern`
- Создаёт директории для core файлов

### 4. analyze_core.sh
- Ищет core файлы в системе
- Запускает GDB анализ
- Генерирует отчёты с backtrace
- Создаёт SUMMARY.txt

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

### Только setup

```bash
cd ~/project && chmod +x *.sh && ./setup_core.sh
```

### Только сервер

```bash
cd ~/project && python3 vulnerable_runtime.py
```

### Только фаззер (в отдельном терминале)

```bash
cd ~/project && python3 fuzzer.py
```

## 📊 Результаты

### Core файлы

```bash
ls -lh ~/project/core.*
```

Ожидаемый размер: 5MB+

### GDB отчёты

```bash
cat ~/project/core_dumps/crash_reports/SUMMARY.txt
```

### Детальный backtrace

```bash
cat ~/project/core_dumps/crash_reports/*.report.txt
```

### Открыть в Windows

```
\\wsl$\Ubuntu-22.04\home\<username>\project\core_dumps\crash_reports\
```

## 🐛 Решение проблем

### "Permission denied" на скриптах

```bash
chmod +x *.sh
```

### "ulimit: unlimited: invalid option"

```bash
ulimit -c unlimited
```

### "Address already in use" (порт 61499)

```bash
pkill -f vulnerable_runtime.py
```

### Core файлы не создаются

```bash
# Проверить настройки
cat /proc/sys/kernel/core_pattern
ulimit -c

# Пересоздать
echo "core.%e.%p.%t" | sudo tee /proc/sys/kernel/core_pattern
ulimit -c unlimited
```

### GDB не установлен

```bash
sudo apt install gdb
```

## 📚 Лабораторная работа

### Ожидаемый результат

✅ 5MB+ core dump файл  
✅ 2+ GDB отчёта с backtrace  
✅ Buffer overflow найден  
✅ SUMMARY.txt готов к сдаче  

### Что сдавать

1. SUMMARY.txt
2. Все *.report.txt файлы
3. Скриншоты вывода
4. Анализ найденной уязвимости

## 🔗 Ссылки

- [Linux Core Dumps](https://averageradical.github.io/LinuxCoreDumps.pdf)
- [GDB Documentation](https://sourceware.org/gdb/documentation/)
- [WSL2 Documentation](https://learn.microsoft.com/en-us/windows/wsl/)

## 📝 Примечания

- Работает в Linux пространстве (`~/project/`), НЕ в `/mnt/d/`
- Core dump включен только в текущей сессии bash
- Для постоянных настроек добавить в `~/.bashrc`
- GDB требует root доступ для некоторых операций

## 👤 Автор

WSL2 Core Dump Analysis Lab v1.0  
Дата: January 2026

---

**Готово к лабораторной работе!** 🎓
