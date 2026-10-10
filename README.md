# 🛒 E-Commerce Sales & Customer Analytics Solution

![Power BI](https://img.shields.io/badge/Power_BI-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black)
![T-SQL](https://img.shields.io/badge/T--SQL-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Data Architecture](https://img.shields.io/badge/Data_Architecture-Star_Schema-blue?style=for-the-badge)
![Data Governance](https://img.shields.io/badge/Data_Governance-Validated-success?style=for-the-badge)

---

## 📌 Executive Summary

Комплексное аналитическое решение (End-to-End Analytics Solution) для бизнеса в сфере электронной коммерции. Проект направлен на выявление драйверов выручки, анализ отмен и возвратов заказов, сегментацию клиентуры по демографии и оптимизацию операционных KPI. Решение объединяет слой ETL и Ad-Hoc валидации на T-SQL с двустраничным интерактивным аналитическим дашбордом в Power BI.

---

## 🖼️ Visual Showcase

### Page 1: Executive Overview & Demographics
*Стратегический обзор ключевых KPI (Revenue, Delivered Revenue, Cancellation Rate, Avg Price, Orders), тренда продаж и демографического профиля клиентов.*
![Executive Overview](./Скриншоты/PART 1.png)

### Page 2: Operational Deep Dive & Status Analysis
*Операционный анализ структуры отмен/возвратов, распределения способов оплаты и уровня отмен по возрастным сегментам.*
![Deep Dive](./Скриншоты/PART 2.png)

---

## 🔄 End-to-End Analytics Workflow

1. **DWH & Data Ingestion (T-SQL / SQL Server):**
   - Импорт и очистка первичных транзакционных данных из источника.
   - Ограничения типов данных, обработка исключений и валидация статусов заказов (`delivered`, `cancelled`, `returned`, `pending`).
2. **Data Modeling & DAX Engine (Power BI):**
   - Разработка Star-Schema модели данных с центральной таблицей фактов `Sales`.
   - Создание изолированной таблицы DAX-мер для расчета выручки, динамических конверсий отмен и средних чеков.
3. **Interactive BI / UI Layer:**
   - Построение интерактивных витрин с кросс-фильтрацией по кварталам, методам оплаты (`payment_mode`) и статусам.

---

## ⚡ Analytical Logic & Governance Matrix

| Бизнес-проблема / Риск искажения | Техническое решение (T-SQL & DAX Code) | Аналитический & Бизнес-Инсайт |
| :--- | :--- | :--- |
| **Искажение выручки из-за нереализованных заказов** | Фильтрация в SQL: `WHERE status = 'delivered'` / DAX-мера: `Delivered Revenue = CALCULATE(SUM(Sales[price] * Sales[quantity]), Sales[status] = "delivered")` | Избежано завышение Revenue на 74.2% (Общая сумма заказов $59.1M vs Реальная доставленная выручка $15.24M). |
| **Ошибки при округлении процента отмен/возвратов** | Точное деление в T-SQL через приведение типов: `CAST(SUM(CASE WHEN status = 'returned' THEN 100.0 ELSE 0 END) / COUNT(*) AS DECIMAL(5,2))` | Расчет корректного KPI `Cancellation Rate %` (24% по компании), предотвращены погрешности целочисленного деления. |
| **Неэффективное таргетирование рекламных кампаний** | Сегментация возрастов через `CASE WHEN customer_age BETWEEN ...` и дакс-группировку `age_group` | Выявлена ключевая доходная группа **36–50 лет** ($19.5M выручки), что позволило перераспределить маркетинговый бюджет. |
| **Скрытые потери от отмен в разрезе демографии** | Создание матрицы `Cancellation Rate % by age_group` (Treemap / Matrix Chart) | Сегменты **26–35** и **51+** генерируют наибольшую долю отмен, что указывает на проблемы на этапе чекаута или логистики. |
| **Неоптимальные комиссии эквайринга** | Агрегация доли платежных систем `COUNT(*) GROUP BY payment_mode` | Метод **UPI** занимает 32.71% от всех транзакций, кредитные карты — 17.29%. Даны рекомендации по пересмотру договоров эквайринга. |

---

## 📈 Analytics Engineering Impact & Performance

- **Оптимизация производительности DWH/PBI:** Модель данных оптимизирована для быстрой кросс-фильтрации. Отклик визуалов и пересчет DAX-мер составляет **<0.2 секунд**.
- **Data Quality Control:** 100% согласованность между SQL Ad-Hoc отчетами и Power BI дашбордом за счет единой логики фильтрации статусов.
- **Управление запасами:** Идентификация Top-5 бестселлеров по количеству позволила снизить риск дефицита на складах (Stockout) для ключевых позиций.

---

## 🤖 AI Usage & Quality Control

В процессе разработки AI-инструменты (Gemini) применились для:
- Оптимизации словарного запаса T-SQL queries и шаблонизации `CASE WHEN` конструкций.
- Валидации корректности DAX-выражений и генерации структурированной документации.
- **Quality Control:** Все сгенерированные AI SQL-скрипты и DAX-меры прошли ручную кросс-проверку на тестовых выборках данных в SQL Server Management Studio (SSMS).

---

## 📁 Repository Structure

```text
e-commerce-sales-customer-analytics/
├── Данные/
│   └── E-Commerce Sales & Customer Analytics ORIGINAL.csv             # Исходные транзакционные данные
├── Power BI/
    └── DAX_MEASURES.docx      #Dax-Меры
│   └──E-Commerce Sales & Customer Analytics Dashboard.pbix       # Рабочий файл дашборда Power BI
├── Скриншоты/
│   ├── PART 1.png           # Part 1: Executive Overview & Demographics
│   ├── PART 2 - DEEP DIVE.png           # Part 2: Operational Deep Dive
│   └── SCHEMA.png           # Model Architecture View
├── Sql/
│   └── E-Commerce Sales & Customer Analytics.sql       # Комплекс из 9 T-SQL запросов для Ad-Hoc анализа
├── .gitignore                     # Исключение временных файлов PBIX / OS
└── README.md                      # Документация проекта
