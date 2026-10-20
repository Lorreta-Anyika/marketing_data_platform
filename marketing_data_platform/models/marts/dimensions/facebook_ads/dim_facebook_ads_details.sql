
WITH facebook_ads AS (

    SELECT *
    FROM {{ ref('int_facebook__ad_details') }}

),

final AS (

    SELECT
        ad_id,
        ad_name,
        ad_status,
        ad_group_id,
        ad_group_name,
        campaign_id,
        campaign_name,
        account_id,
        account_name,
        ad_currency_code,
        ad_updated_at,
        platform,
        channel_name

    FROM facebook_ads

)

SELECT *
FROM final
