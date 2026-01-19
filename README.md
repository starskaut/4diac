# Макет среды разработки для IEC 61499 (вариант 1 — аналог 4diac)

Репозиторий для лабораторных работ по дисциплине "Инструментальные средства информационных систем".

Покрывает:
- ЛР1: Установка 4diac/FORTE, тестовый проект "Hello world", ТЗ (tz.md)
- ЛР2: Анализ протокола (Wireshark), макет загрузки (deploy_client.py)
- ЛР3: Макет кода (vulnerable_runtime.py), фаззинг (fuzzer.py), анализ core (analyze_core.sh)
- ЛР4: ПМИ (PMI.md → PMI.pdf), GitHub Actions для PDF, логи тестов

## Структура
├── PMI.md
├── tz.md
├── deploy_client.py
├── vulnerable_runtime.py
├── fuzzer.py
├── analyze_core.sh
├── setup_core.sh
├── test_command.xml
└── .github/workflows/build_pdf.yml

## Запуск
python vulnerable_runtime.py
python deploy_client.py
python fuzzer.py
./setup_core.sh
./analyze_core.sh

PDF генерируется автоматически через GitHub Actions.