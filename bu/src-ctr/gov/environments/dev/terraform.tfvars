# Console login user should be added to lake formation administrator group in development environments. 
# else console user will not be able to view the glue db and tables managed by Lake Formation
administrator_users = ["arn:aws:iam::165729034722:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_f37417a9e1e64941"]


# Name of the pipeline / function / report for which this pattern is being created
pipeline_name = "gov"
