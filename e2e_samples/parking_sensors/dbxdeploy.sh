databricks_host=https://adb-3180609913437653.13.azuredatabricks.net
workspace_name=mycooldbx5
resource_group=mysecondrg
subscription=ac2ad472-6e23-430d-85ff-1d1d8057d550
databricks_aad_token=$(az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d --output json | jq -r .accessToken) 
export DATABRICKS_AAD_TOKEN=$databricks_aad_token
management_token=$(az account get-access-token --resource https://management.core.windows.net/ --output json | jq -r .accessToken)
databricks configure --host "$databricks_host"  --aad-token
echo "Fine Here"
curl -X GET \
-H "Authorization: Bearer $DATABRICKS_AAD_TOKEN" \
-H "X-Databricks-Azure-SP-Management-Token: $management_token" \
-H "X-Databricks-Azure-Workspace-Resource-Id: /subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.Databricks/workspaces/$workspace_name" \
$databricks_host/api/2.0/clusters/list
# Use AAD token to generate PAT token
databricks_token=$(databricks tokens create --comment 'deployment' | jq -r .token_value)
echo "Done"
# az login --service-principal --username c46b1d12-5623-4648-b945-c1454a28641f --password m3N8Q~JqLf~NZhKMw4jNATuke7WpJKgPvfnG3bo0 --tenant 16b3c013-d300-468d-ac64-7eda0820b6d3



echo "Generate Databricks token"
databricks_host=https://$(echo "$arm_output" | jq -r '.properties.outputs.databricks_output.value.properties.workspaceUrl')
databricks_workspace_resource_id=$(echo "$arm_output" | jq -r '.properties.outputs.databricks_id.value')
databricks_aad_token=$(az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d --output json | jq -r .accessToken) # Databricks app global id
export DATABRICKS_AAD_TOKEN=$databricks_aad_token
databricks configure --host "$databricks_host"  --aad-token
management_token=$(az account get-access-token --resource https://management.core.windows.net/ --output json | jq -r .accessToken)

curl -X GET \
-H "Authorization: Bearer $DATABRICKS_AAD_TOKEN" \
-H "X-Databricks-Azure-SP-Management-Token: $management_token" \
-H "X-Databricks-Azure-Workspace-Resource-Id: $databricks_workspace_resource_id" \
$databricks_host/api/2.0/clusters/list