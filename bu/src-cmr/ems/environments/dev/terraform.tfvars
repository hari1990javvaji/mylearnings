pipeline_name = "ems"
# Console login user should be added to lake formation administrator group in development environments. 
# else console user will not be able to view the glue db and tables managed by Lake Formation
administrator_users = ["arn:aws:iam::942328815196:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_65549ee6dcb32e15"]

athena_workgroups = {
  "data-engineering" = {
    "description" : "Data Engineering team workgroup"
    "bytes_scanned" : 21474836480
    "workgroup" : true
    "cloudwatch_enabled" : false
  },
  "data-architecture" = {
    "description" : "Data Architecture team workgroup"
  },
  "data-science" = {
    "description" : "Data Science team workgroup"
  },
  "data-analysis" = {
    "description" : "Data Analysis team workgroup"
  }

}