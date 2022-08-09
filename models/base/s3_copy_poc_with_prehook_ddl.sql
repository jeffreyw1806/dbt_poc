/* In this poc, I used an alternative way to load  a large csv.
   The size of the input file is around 50GB, when using the traditional method
   with Redshift spectum, it took over 3 hours to load the file from s3 to a redshift
   base table with exactly the same columns. With this method, it took only about
   20-30 minutes.
*/
{{ config (

        pre_hook= [
        " CREATE TABLE IF NOT EXISTS {{this}}
        (
            sequence_number VARCHAR(255)   ENCODE lzo
	          ,claim_id VARCHAR(255)   ENCODE lzo
	          ,line_num VARCHAR(255)   ENCODE lzo
	          ,contract_id VARCHAR(255)   ENCODE lzo
	          ,member_id VARCHAR(255)   ENCODE lzo
	          ,dob VARCHAR(255)   ENCODE lzo
	          ,gender VARCHAR(255)   ENCODE lzo
	          ,from_date VARCHAR(255)   ENCODE lzo
	          ,to_date VARCHAR(255)   ENCODE lzo
        )
        DISTSTYLE auto; " ,
        " truncate table {{this}} ",
        " copy {{this}} from 's3://abc/xyz/'
          iam_role 'arn:aws:iam::123456789:role/redshift-user1' delimiter '|'; "
        ]
) }}

SELECT * FROM {{ this }}
