# 📘 توثيق مستودع بيانات Olist المتطور (Advanced Olist DWH)

هذا المشروع يطبق بنية مستودع بيانات احترافية تعتمد على **Star Schema** مع دعم لـ **Surrogate Keys** و **SCD Type 2**.

---

## 🏗️ مخطط قاعدة البيانات (Data Warehouse Schema)

تم تصميم المستودع ليكون مركزياً وقابلاً للتوسع، مع فصل الأداء اللوجستي عن أداء المبيعات.

```mermaid
erDiagram
    DIM_CUSTOMER ||--o{ FACT_ORDER_ITEMS : "buys"
    DIM_PRODUCT ||--o{ FACT_ORDER_ITEMS : "included in"
    DIM_SELLER ||--o{ FACT_ORDER_ITEMS : "sells"
    DIM_ORDER ||--o{ FACT_ORDER_ITEMS : "contains"
    DIM_DATE ||--o{ FACT_ORDER_ITEMS : "placed on"

    DIM_CUSTOMER ||--o{ FACT_DELIVERY_PERFORMANCE : "belongs to"
    DIM_SELLER ||--o{ FACT_DELIVERY_PERFORMANCE : "shipped by"
    DIM_PRODUCT ||--o{ FACT_DELIVERY_PERFORMANCE : "item type"
    DIM_ORDER ||--o{ FACT_DELIVERY_PERFORMANCE : "order info"
    DIM_DATE ||--o{ FACT_DELIVERY_PERFORMANCE : "performance date"

    DIM_CUSTOMER {
        bigint customer_key PK
        text customer_id
        text customer_unique_id
        text customer_city
        text customer_state
        timestamp start_date
        timestamp end_date
        int is_current
    }

    DIM_PRODUCT {
        bigint product_key PK
        text product_id
        text product_category_name_english
        double product_weight_g
        timestamp start_date
        int is_current
    }

    DIM_DATE {
        bigint date_key PK
        timestamp full_date
        int year
        int quarter
        int month
        text day_of_week
        int is_weekend
    }

    FACT_ORDER_ITEMS {
        bigint order_key FK
        bigint customer_key FK
        bigint product_key FK
        bigint seller_key FK
        bigint date_key FK
        double sales_amount
        double freight_amount
        bigint quantity
    }

    FACT_DELIVERY_PERFORMANCE {
        bigint customer_key FK
        bigint seller_key FK
        bigint product_key FK
        bigint order_key FK
        bigint date_key FK
        double delivery_days
        double late_days
        double approval_delay
        double carrier_delay
    }
```

---

## 🛠️ خطة نقل البيانات (ETL Pipeline)

1.  **Extract:** استخراج البيانات من SQLite وجداول CSV.
2.  **Transform:**
    *   **Surrogate Keys:** إنشاء مفاتيح بديلة (SK) لكل الأبعاد لضمان استقلالية البيانات.
    *   **SCD Type 2:** إضافة أعمدة تتبع التغيير التاريخي (`start_date`, `end_date`, `is_current`).
    *   **Calculations:** حساب أيام التأخير، زمن الموافقة، وزمن الشحن لجدول الأداء.
3.  **Load:** تحميل البيانات إلى **PostgreSQL المحلي** مع تعريف الأنواع الصحيحة.

---

## 🚀 كيفية التشغيل (Local Deployment)

1.  تأكد من أن قاعدة بيانات PostgreSQL تعمل على جهازك.
2.  قم بإنشاء قاعدة بيانات باسم `ecommerce_dwh` (أو عدل الاسم في الكود).
3.  افتح ملف `ETL.ipynb` وقم بتعديل قسم **CONFIGURATION** ببياناتك الخاصة (اسم المستخدم، كلمة المرور، المنفذ).
4.  شغل جميع الخلايا لتنفيذ عملية نقل البيانات.
