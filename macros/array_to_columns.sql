/*
The macro below splits an array of values into seperate columns.
input_array -> array to split
max_columns -> max number of columns to create
seperator -> text to split string by
*/

{% macro array_to_columns(input_array, max_columns, seperator) %}

{% for i in range(max_columns) %}
    nullif(
        replace(
            split(
                replace(trim({{ input_array }}, '[]'), '"'),
                '{{ seperator }}'
            )[{{ i }}],
            '"'
        ),
        ''
    ) as genre{{ i + 1 }}{% if not loop.last %},{% endif %}
{% endfor %}

{% endmacro %}  