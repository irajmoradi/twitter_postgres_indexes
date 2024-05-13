Select tag, count(distinct id_tweets)
from (
    select data->>'id' as id_tweets,
    '#' || (jsonb_array_elements(coalesce(data->'entities'->'hashtags','[]') || 
            coalesce(data->'extended_tweet'->'entities'->'hashtags','[]'))->>'text'::TEXT) as tag
        from tweets_jsonb
        where
        data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]' 
        OR
        data->'extended_tweet'->'entities'->'hashtags' @> '[{"text":"coronavirus"}]'
    ) t
    GROUP BY tag
    order by count desc, tag
    limit 1000;
