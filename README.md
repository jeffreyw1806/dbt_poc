Welcome to Jeffrey's dbt poc project!

### Using the starter project

This project contains some of the POC models I built in my spare time, when working with others in dbt slack
Please notice that I used Redshift and Snowfake as the databsae, and this project is not related to my current and past jobs.

list of POCs:

1. Parse Redshift stl_qury to build a historical performance table for dbt.
~\dbt_poc\models\edw_model\performance\dbt_performance_measures.sql

2. Automatcailly clone Redshift tables from one cluster to another using Datashare
～\dbt_poc\macros\clone_prod_tables.sql

3. POC on s3 copy using dbt
~\dbt_poc\models\base\s3_copy_poc_with_prehook_ddl.sql

4. POC on a custome Macro to verify that out of a list of distinct columns, the selected columns are unique
~\dbt_poc\macros\test_unique_test_on_distinct_columns.sql

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
