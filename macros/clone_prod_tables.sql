{% macro clone_prod_tables(table_list, schema_name, days_look_back='7') %}
    
    {# query info schema to get list of table objects #}
    {% set table_list_query %}
        select distinct model_type||'.'||dbt_model_name as schema_and_table_name from jsix_datashare_consumer.performance.dbt_performance_measures dpm where dbt_run_type='run' and job_status='completed'
        and model_type in  ('{{ schema_name | replace(',', '\',\'') }}') and start_time> current_date - interval '{{days_look_back}} days' 
        {% if table_list %}
            union
            select distinct schema_and_table_name from jsix_pre_prod.{{ table_list }} 
        {% endif %}    
    {% endset %}

    {% if execute %}
        {%- if 'pre_prod' in target.name -%}
            {# run query and save tables to a list #}
            {% set table_list = run_query(table_list_query).columns[0].values() %}

            {# loop through tables and create in new schema with CTAS statement #}
            {% for table in table_list %}

                {% set query_to_run = 'drop table if exists jsix_pre_prod.'~table~';
                    create table jsix_pre_prod.'~table~' as select * from jsix_datashare_consumer.'~table~' '  %}
                {{ log('createing talbe: '~table~'') }}
                {% do run_query(query_to_run) %}

            {% endfor %}
        {% endif %}

    {% endif %}


{% endmacro %}
