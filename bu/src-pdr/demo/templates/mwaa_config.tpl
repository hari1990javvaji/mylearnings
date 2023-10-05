[EMR]
%{ for config_key, config_value in emr_config ~}
${config_key} = ${config_value}
%{ endfor ~}

[Glue]
%{ for config_key, config_value in glue_config ~}
${config_key} = ${config_value}
%{ endfor ~}
