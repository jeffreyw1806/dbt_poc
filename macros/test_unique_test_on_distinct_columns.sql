{# Ensure that out of distinct columns, the selected columns are unique #}

{% macro test_unique_test_on_distinct_columns(model, combination_of_unique_columns,combination_of_distinct_columns,quote_columns=false) %}

{% if not quote_columns %}
    {%- set unique_column_list=combination_of_unique_columns %}
    {%- set distinct_column_list=combination_of_distinct_columns %}    
{% elif quote_columns %}
    {%- set unique_column_list=[] %}
        {% for column in combination_of_unique_columns -%}
            {% set unique_column_list = unique_column_list.append( adapter.quote(column) ) %}
        {%- endfor %}
    {%- set distinct_column_list=[] %}
        {% for column in combination_of_distinct_columns -%}
            {% set distinct_column_list = distinct_column_list.append( adapter.quote(column) ) %}
        {%- endfor %}    
{% else %}
    {{ exceptions.raise_compiler_error(
        "`quote_columns` argument for unique_test_on_distinct_columns test must be one of [True, False] Got: '" ~ quote ~"'.'"
    ) }}
{% endif %}

{%- set unique_columns_csv=unique_column_list | join(', ') %}
{%- set distinct_columns_csv=distinct_column_list | join(', ') %}
 
with src_distinct_columns as (

    select
        distinct {{ distinct_columns_csv }}
    from {{ model }}

),

validation_errors as (

    select
        {{ unique_columns_csv }}
    from src_distinct_columns
    group by {{ unique_columns_csv }}
    having count(*) > 1

)

select *
from validation_errors

{% endmacro %}
