resource "aws_cloudwatch_dashboard" "mwaa_cw_dashboard" {
  dashboard_name = var.mwaa_env_name
  dashboard_body = templatefile("${path.module}/cw_dashboard.json", { region = var.region, mwaa_env = var.mwaa_env_name })
}

resource "aws_cloudwatch_metric_alarm" "mwaa_scheduler_hearbeat_alarm" {
  alarm_name          = "${var.mwaa_env_name}-heartbeat-failure"
  alarm_description   = "less than normal scheduler hearbeats for 3 consecutive periods"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 3
  metric_name         = "SchedulerHeartbeat"
  namespace           = "AmazonMWAA"
  period              = 60
  statistic           = "Sum"
  threshold           = 0.0
  treat_missing_data  = "missing"
  actions_enabled     = "true"
  alarm_actions       = [var.mwaa_alerts_sns_topic_arn]
  dimensions = {
    Function    = "Scheduler"
    Environment = var.mwaa_env_name
  }
  tags = var.tags
}


resource "aws_cloudwatch_metric_alarm" "mwaa_unhealthy_worker" {
  alarm_name          = "${var.mwaa_env_name}-unhealthy-worker"
  alarm_description   = "Worker tasks queued and no tasks running for 1 minute"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  treat_missing_data  = "missing"
  threshold           = 0.0
  actions_enabled     = "true"
  alarm_actions       = [var.mwaa_alerts_sns_topic_arn]
  tags                = var.tags

  metric_query {
    id          = "e1"
    label       = "QueuedGreaterThanRunningAndRunningIsZero"
    expression  = "IF(m1 > m2 AND m2 == 0, 1, 0)"
    return_data = true
  }
  metric_query {
    id          = "m1"
    return_data = false
    metric {
      metric_name = "QueuedTasks"
      namespace   = "AmazonMWAA"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        Function    = "Executor"
        Environment = var.mwaa_env_name
      }
    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "RunningTasks"
      namespace   = "AmazonMWAA"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        Function    = "Executor"
        Environment = var.mwaa_env_name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "mwaa_under_provisioned_workers" {
  alarm_name          = "${var.mwaa_env_name}-under-provisioned-workers"
  alarm_description   = "required number of workers is greater than %90 of max workers for 3 consecutive periods"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 3
  treat_missing_data  = "missing"
  threshold           = 0.0
  actions_enabled     = "true"
  alarm_actions       = [var.mwaa_alerts_sns_topic_arn]
  tags                = var.tags

  metric_query {
    id          = "e1"
    label       = "RequiredNumOfWorkersGreaterThan%90OfMaxWorkers"
    expression  = "IF(((m1+m2)/${var.tasks_per_worker[var.mwaa_env_class]} > (${var.mwaa_max_workers}*0.9)) , 1, 0)"
    return_data = true
  }
  metric_query {
    id          = "m1"
    return_data = false
    metric {
      metric_name = "QueuedTasks"
      namespace   = "AmazonMWAA"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        Function    = "Executor"
        Environment = var.mwaa_env_name
      }
    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "RunningTasks"
      namespace   = "AmazonMWAA"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        Function    = "Executor"
        Environment = var.mwaa_env_name
      }
    }
  }
}