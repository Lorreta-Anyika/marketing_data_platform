
WITH source_data AS (

    SELECT *
    FROM {{ source('snapchat', 'snapchat_ads_stats') }}

),

formatted AS (

    SELECT
        -- Identifiers
        CAST(ad_detail_id AS STRING) AS ad_id,

        -- Performance metrics
        CAST(ad_spend AS DOUBLE) AS ad_spend,

        CAST(ad_impressions AS BIGINT) AS ad_impressions,

        CAST(
            NULLIF(TRIM(ad_clicks), 'null')
            AS BIGINT
        ) AS ad_clicks,

        -- Reporting dimensions
        CAST(ad_date AS DATE) AS ad_date,
        CAST(ad_country AS STRING) AS ad_country,
        CAST(ad_currency_code AS STRING) AS ad_currency_code,
        CAST(data_src AS STRING) AS data_src

    FROM source_data

)

SELECT *
FROM formatted
