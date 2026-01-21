select *
from {{ ref('spotify_reporting') }}
where track_popularity < 0
    or track_popularity > 100
    or artist_popularity < 0
    or artist_popularity > 100