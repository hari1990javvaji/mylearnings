Steps to deploy and use the code

1. Upload the `custom` folder and it contents into MWAA dags folder
2. Upload the `sample_dag.py` nto MWAA dags folder.
3. Edit existing `.airflowignore` file and add FOLLWING ENTRY
        `custom` 
4. Add following policy to the MWAA execution role

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "elasticmapreduce:*",
                "ec2:DescribeRouteTables"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::<AccountNo>:role/EMR_DefaultRole",
                "arn:aws:iam::<AccountNo>:role/EMR_EC2_DefaultRole"
            ]
        }
    ]
}
```


Refresh the MWAA UI and DAG should show up
