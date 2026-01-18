{% macro split_to_columns(column_sql, max_columns) %}

{% set col = column_sql %}

{% for i in range(max_columns) %}
    nullif(
        replace(
            split(
                replace(trim({{ col }}, '[]'), '"'),
                ','
            )[{{ i }}],
            '"'
        ),
        ''
    ) as genre{{ i + 1 }}{% if not loop.last %},{% endif %}
{% endfor %}

{% endmacro %}