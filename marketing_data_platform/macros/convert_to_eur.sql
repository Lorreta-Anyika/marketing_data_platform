
{% macro convert_to_eur(amount, currency, rate) %}
    CASE
        WHEN {{ currency }} = 'EUR' THEN {{ amount }}
        WHEN {{ currency }} = 'USD'
            AND {{ rate }} IS NOT NULL
            AND {{ rate }} > 0
            THEN {{ amount }} / {{ rate }}
        ELSE NULL
    END
{% endmacro %}
