
WITH snapchat_performance AS (

    SELECT *
    FROM {{ ref('int_marketing__ad_performance') }}
    WHERE LOWER(platform) = 'snapchat'

),

final AS (

    SELECT
        platform,
        ad_id,
        ad_date,
        ad_country,
        ad_currency_code,
        ad_spend,
        spend_eur,
        ad_impressions,
        ad_clicks,

        CASE
            WHEN ad_impressions > 0
            THEN ad_clicks * 100.0 / ad_impressions
            ELSE NULL
        END AS ctr,

        CASE
            WHEN ad_clicks > 0
            THEN spend_eur / ad_clicks
            ELSE NULL
        END AS cpc_eur,

        CASE
            WHEN ad_impressions > 0
            THEN spend_eur * 1000.0 / ad_impressions
            ELSE NULL
        END AS cpm_eur

    FROM snapchat_performance

)

SELECT *
FROM final
