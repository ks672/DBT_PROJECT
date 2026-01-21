
/*
    This script builds a reporting table in snowflake for spotify data. 
    This will feed into a data visualisation tool.
*/

{{ config(materialized='incremental',  unique_key='fact_playlist_track_id') }}

select
    distinct
    fpt.fact_playlist_track_id,
    fpt.added_at,
    fpt.track_name,
    fpt.artist_name,
    fpt.album_name,
    {{ array_to_columns('a.genres', 9, ',') }},
    a.followers,
    a.popularity as artist_popularity,
    
    t.popularity as track_popularity,
    t.duration_ms,
    t.explicit,
    fpt.load_timestamp as source_load_timestamp,
    current_timestamp() as load_timestamp

    from spotify_db.curated.fact_playlist_track fpt

    left join spotify_db.curated.artist a
    on fpt.artist_id = a.artist_id
    --dedupe track table
    left join (select track_id, popularity, duration_ms, explicit, load_timestamp, updated_timestamp from spotify_db.curated.track qualify row_number() over(partition by track_id order by load_timestamp desc, coalesce(updated_timestamp,'1900-01-01') desc) = 1) t
    on fpt.track_id = t.track_id

    {% if is_incremental() %}
        where fpt.load_timestamp > (select coalesce(max(source_load_timestamp),'1900-01-01') from {{ this }})
    {% endif %}